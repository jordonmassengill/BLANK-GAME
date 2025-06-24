/// @function create_ai_component(owner_entity, config)
/// @description Creates a state-driven AI component for an entity.
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
		},
		target: noone,
		patrol_dir: choose(1, -1),
		attack_timer: 0,
		melee_cooldown: 0,

		update: function() {
			if (self.melee_cooldown > 0) {
				self.melee_cooldown--;
			}
			self.state_machine.update();
		},
		
		_find_target: function() {
			var inst = self.owner.owner_instance;
			var closest = instance_nearest(inst.x, inst.y, obj_player_creature_parent);
			if (closest != noone) {
				var dist = point_distance(inst.x, inst.y, closest.x, closest.y);
				if (dist < self.config.detection_range) { self.target = closest; }
				else { self.target = noone; }
			} else {
				self.target = noone;
			}
		}
	};

	var sm = component.state_machine;
	sm.init(component);

	// STATE: PATROL
	sm.add_state("PATROL",
		method(component, function() { // On Enter
			self.target = noone;
			// Set the speed multiplier for patrol
			self.owner.movement.set_speed_multiplier(self.config.patrol_speed_mult);
			// Set the initial direction
			self.owner.movement.set_input_xy(self.patrol_dir, 0);
		}),
		method(component, function() { // On Update
			self._find_target();
			if (self.target != noone) {
				self.state_machine.change_state("CHASE");
				return;
			}
			var is_at_ledge = false;
			with (self.owner.owner_instance) {
				var check_x = (other.patrol_dir == 1) ? bbox_right + 2 : bbox_left - 2;
				if (!position_meeting(check_x, bbox_bottom + 1, obj_floor)) {
					is_at_ledge = true;
				}
			}
			if (is_at_ledge) {
				self.patrol_dir *= -1;
				self.owner.movement.set_input_xy(self.patrol_dir, 0);
			}
		})
	);

	// STATE: CHASE
	sm.add_state("CHASE",
		method(component, function() { // On Enter
			// Reset to full speed (multiplier of 1.0) for chase
			self.owner.movement.set_speed_multiplier(1.0);
		}),
		method(component, function() { // On Update
			if (self.target == noone || !instance_exists(self.target) ||
				point_distance(self.owner.owner_instance.x, 0, self.target.x, 0) > self.config.lose_target_range) {
				self.target = noone;
				self.state_machine.change_state("PATROL");
				return;
			}
			
			var dist = point_distance(self.owner.owner_instance.x, 0, self.target.x, 0);

			if (dist <= self.config.melee_range && self.melee_cooldown <= 0) {
				self.state_machine.change_state("MELEE_ATTACK");
				return;
			}
			
			if (self.owner.weapon.can_fire()) {
				self.state_machine.change_state("RANGED_ATTACK");
				return;
			}

			var should_move = true;
			var inst = self.owner.owner_instance;
			var move_dir = sign(self.target.x - inst.x);
			
			var stable_sprite_for_check = sOrchydeIdle;
			var sprite_x_offset = sprite_get_xoffset(stable_sprite_for_check);
			var bbox_left_relative = sprite_get_bbox_left(stable_sprite_for_check) - sprite_x_offset;
			var bbox_right_relative = sprite_get_bbox_right(stable_sprite_for_check) - sprite_x_offset;
			
			var check_x = inst.x;
			if (move_dir == 1) {
				check_x += bbox_right_relative + 2;
			} else {
				check_x += bbox_left_relative - 2;
			}
			
			if (!position_meeting(check_x, inst.bbox_bottom + 1, obj_floor)) {
				should_move = false;
			}
			
			if (should_move) {
				self.owner.movement.set_input_xy(move_dir, 0);
			} else {
				self.owner.movement.set_input_xy(0, 0);
			}
		})
	);
	
	// ATTACK STATES
	sm.add_state("MELEE_ATTACK",
		method(component, function() {
			self.attack_timer = self.config.attack_anim_time;
			self.owner.movement.set_input_xy(0, 0);
			self.owner.weapon.fire(self.target, true);
			self.melee_cooldown = self.config.melee_cooldown_max;
		}),
		method(component, function() {
			self.attack_timer--;
			if (self.attack_timer <= 0) {
				self.state_machine.change_state("CHASE");
			}
		})
	);

	sm.add_state("RANGED_ATTACK",
		method(component, function() {
			self.attack_timer = self.config.attack_anim_time;
			self.owner.movement.set_input_xy(0, 0);
			self.owner.weapon.fire(self.target, false);
		}),
		method(component, function() {
			self.attack_timer--;
			if (self.attack_timer <= 0) {
				self.state_machine.change_state("CHASE");
			}
		})
	);

	sm.change_state("PATROL");
	return component;
}