/// @function create_ai_component(owner_entity, config)
/// @description Creates a state-driven AI component for an entity. (VERSION 5 - Final)
function create_ai_component(owner_entity, config) {
	
	var component = {
		owner: owner_entity,
		state_machine: create_state_machine(),
		config: {
			detection_range: config.detection_range ?? 300,
			lose_target_range: config.lose_target_range ?? 450,
			melee_range: config.melee_range ?? 56,
			patrol_speed_mult: config.patrol_speed_mult ?? 0.5,
			attack_anim_time: config.attack_anim_time ?? 45,
			melee_cooldown_max: config.melee_cooldown_max ?? 90,
			body_width_left: variable_struct_exists(config, "body_width_left") ? config.body_width_left : 16,
			body_width_right: variable_struct_exists(config, "body_width_right") ? config.body_width_right : 16,
		},
		target: noone,
		patrol_dir: choose(1, -1),
		attack_timer: 0,
		melee_cooldown: 0,
		shot_has_fired_this_state: false,

		update: function() {
			if (self.melee_cooldown > 0) {
				self.melee_cooldown--;
			}
			self.state_machine.update();
		},
		
		_find_target: function() {
			var inst = self.owner.owner_instance;
			var closest = instance_nearest(inst.x, inst.y, obj_player_creature_parent);
			
			if (instance_exists(closest)) {
				var dist = point_distance(inst.x, inst.y, closest.x, closest.y);
				if (dist < self.config.detection_range) {
					self.target = closest;
				} else {
					self.target = noone;
				}
			} else {
				self.target = noone;
			}
		},
		
		_has_ground_ahead: function(move_dir) {
			var inst = self.owner.owner_instance;
			var offset = (move_dir == 1) ? self.config.body_width_right : -self.config.body_width_left;
			var check_x = inst.x + offset;
			return position_meeting(check_x, inst.bbox_bottom + 1, obj_floor);
		}
	};

	var sm = component.state_machine;
	sm.init(component);

	// --- STATE DEFINITIONS ---

	sm.add_state("EVALUATE",
		undefined, 
		method(component, function() {
			var inst = self.owner.owner_instance;
			
			if (self.target == noone || !instance_exists(self.target) ||
				point_distance(inst.x, 0, self.target.x, 0) > self.config.lose_target_range) {
				self.target = noone;
				self.state_machine.change_state("PATROL");
				return;
			}
			
			var dist = point_distance(inst.x, 0, self.target.x, 0);
			if (dist <= self.config.melee_range && self.melee_cooldown <= 0) {
				self.state_machine.change_state("MELEE_ATTACK");
			} else if (self.owner.weapon.can_fire()) {
				self.state_machine.change_state("RANGED_ATTACK");
			} else {
				self.state_machine.change_state("CHASE");
			}
		})
	);
	
	sm.add_state("PATROL",
		method(component, function() {
			self.target = noone;
			self.owner.movement.set_speed_multiplier(self.config.patrol_speed_mult);
			self.owner.movement.set_input_xy(self.patrol_dir, 0);
			self.owner.owner_instance.creature.facing_direction = (self.patrol_dir == 1) ? "right" : "left";

		}),
		method(component, function() {
			self._find_target();
			if (self.target != noone) {
				self.state_machine.change_state("CHASE");
				return;
			}
			
			if (!self._has_ground_ahead(self.patrol_dir)) {
				self.patrol_dir *= -1;
				self.owner.movement.set_input_xy(self.patrol_dir, 0);
				// NEW: Explicitly set the facing direction when turning during patrol.
				self.owner.owner_instance.creature.facing_direction = (self.patrol_dir == 1) ? "right" : "left";
			}
		})
	);

	sm.add_state("CHASE",
		method(component, function() {
			self.owner.movement.set_speed_multiplier(1.0);
		}),
		method(component, function() {
			self.state_machine.change_state("EVALUATE");

			if (instance_exists(self.target)) {
				var move_dir = sign(self.target.x - self.owner.owner_instance.x);
				
				// NEW: Explicitly set the facing direction every frame while chasing.
				self.owner.owner_instance.creature.facing_direction = (move_dir == 1) ? "right" : "left";

				if (self._has_ground_ahead(move_dir)) {
					self.owner.movement.set_input_xy(move_dir, 0);
				} else {
					self.owner.movement.set_input_xy(0, 0);
				}
			}
		})
	);
	
	sm.add_state("MELEE_ATTACK",
		method(component, function() { // On Enter
			self.attack_timer = self.config.attack_anim_time;
			self.owner.movement.set_input_xy(0, 0);
			self.owner.weapon.fire(self.target, true);
			self.melee_cooldown = self.config.melee_cooldown_max;
		}),
		method(component, function() { // On Update
			self.attack_timer--;
			if (self.attack_timer <= 0) {
				self.state_machine.change_state("EVALUATE");
			}
		})
	);

	// CHANGED: The logic inside RANGED_ATTACK is completely new to handle turning and delay.
	sm.add_state("RANGED_ATTACK",
		method(component, function() { // On Enter state
			self.attack_timer = self.config.attack_anim_time;
			self.owner.movement.set_input_xy(0, 0);
			self.shot_has_fired_this_state = false;

			// Immediately turn to face the target
			var inst = self.owner.owner_instance;
			if (instance_exists(self.target)) {
				var target_dir = sign(self.target.x - inst.x);
				inst.creature.facing_direction = (target_dir == 1) ? "right" : "left";
			}
		}),
		method(component, function() { // On Update state
			var fire_delay_frames = 5;

			if (self.attack_timer > self.config.attack_anim_time - fire_delay_frames) {
				// This is the aiming delay. Do nothing.
			}
			else if (!self.shot_has_fired_this_state) {
				self.owner.weapon.fire(self.target, false);
				self.shot_has_fired_this_state = true;
			}

			self.attack_timer--;
			if (self.attack_timer <= 0) {
				self.state_machine.change_state("EVALUATE");
			}
		})
	);

	sm.change_state("PATROL");
	return component;
}