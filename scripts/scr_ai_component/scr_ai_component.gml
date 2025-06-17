/// @function create_ai_component(owner_entity, config)
/// @description Creates a state-driven AI component for an entity. (v3 - Simplified Logic)
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
		},
		target: noone,
		patrol_dir: choose(1, -1),
		attack_timer: 0,

		update: function() {
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

	// STATE: PATROL - Unchanged, this part is working correctly.
	sm.add_state("PATROL",
		method(component, function() {
			self.target = noone;
			self.owner.movement.set_input_xy(self.patrol_dir * self.config.patrol_speed_mult, 0);
		}),
		method(component, function() {
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
				self.owner.movement.set_input_xy(self.patrol_dir * self.config.patrol_speed_mult, 0);
			}
		})
	);

	// STATE: CHASE - Rewritten to be smarter and not need a separate "guard" state.
	sm.add_state("CHASE",
		method(component, function() { /* On Enter - does nothing */ }),
		method(component, function() { // On Update
			// 1. Check if we should give up and go back to patrolling.
			if (self.target == noone || !instance_exists(self.target) || 
				point_distance(self.owner.owner_instance.x, 0, self.target.x, 0) > self.config.lose_target_range) {
				self.target = noone;
				self.state_machine.change_state("PATROL");
				return;
			}
			
			// 2. Check if we are close enough to melee.
			var dist = point_distance(self.owner.owner_instance.x, 0, self.target.x, 0);
			if (dist <= self.config.melee_range) {
				self.state_machine.change_state("MELEE_ATTACK");
				return;
			}
			
			// 3. Check for a ledge in the direction of the target.
			var move_dir = sign(self.target.x - self.owner.owner_instance.x);
			var has_floor_ahead = false;
			with(self.owner.owner_instance) {
				var check_x = (move_dir == 1) ? bbox_right + 2 : bbox_left - 2;
				if (position_meeting(check_x, bbox_bottom + 1, obj_floor)) {
					has_floor_ahead = true;
				}
			}

			// 4. Decide what to do based on the ledge check and weapon cooldown.
			if (!has_floor_ahead) {
				// There's a cliff! Stop moving.
				self.owner.movement.set_input_xy(0, 0);
				// We are STILL in the CHASE state. Now check if we can shoot from here.
				if (self.owner.weapon.can_fire()) {
					self.state_machine.change_state("RANGED_ATTACK");
				}
			} else if (self.owner.weapon.can_fire()) {
				// Path is clear AND we can shoot.
				self.state_machine.change_state("RANGED_ATTACK");
			} else {
				// Path is clear but weapon is on cooldown, so keep moving.
				self.owner.movement.set_input_xy(move_dir, 0);
			}
		})
	);
	
	// ATTACK STATES - Now always return to CHASE.
	sm.add_state("MELEE_ATTACK",
		method(component, function() {
			self.attack_timer = self.config.attack_anim_time;
			self.owner.movement.set_input_xy(0, 0);
			self.owner.weapon.fire(self.target, true);
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