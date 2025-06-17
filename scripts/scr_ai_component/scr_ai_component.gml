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
			// ADDED THIS: Default cooldown of 90 frames (1.5 seconds)
			melee_cooldown_max: config.melee_cooldown_max ?? 90,
		},
		target: noone,
		patrol_dir: choose(1, -1),
		attack_timer: 0,
		// ADDED THIS: The cooldown timer variable
		melee_cooldown: 0,

		update: function() {
			// ADDED THIS: Count down the timer each frame
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

	// STATE: CHASE (with bug fix)
	sm.add_state("CHASE",
		method(component, function() { /* On Enter - does nothing */ }),
		method(component, function() { // On Update
			// 1. Check if we should give up and go back to patrolling.
			if (self.target == noone || !instance_exists(self.target) ||
				point_distance(self.owner.owner_instance.x, 0, self.target.x, 0) > self.config.lose_target_range) {
				self.target = noone;
				self.state_machine.change_state("PATROL");
				return; // Exit early
			}
			
			// --- ATTACK LOGIC ---
			// First, decide if an attack should happen. This takes priority over movement.
			var dist = point_distance(self.owner.owner_instance.x, 0, self.target.x, 0);

			// If in melee range AND cooldown is ready, always prefer melee.
			// MODIFIED THIS LINE
			if (dist <= self.config.melee_range && self.melee_cooldown <= 0) {
				self.state_machine.change_state("MELEE_ATTACK");
				return; // Attack and skip movement logic for this frame
			}
			
			// If not in melee range, check for ranged attack.
			if (self.owner.weapon.can_fire()) {
				self.state_machine.change_state("RANGED_ATTACK");
				return; // Attack and skip movement logic for this frame
			}

			// --- MOVEMENT LOGIC (Stable & Accurate Ledge Check) ---
			var should_move = true;
			var inst = self.owner.owner_instance;
			var move_dir = sign(self.target.x - inst.x);
			
			// This is the stable ledge check. It's accurate regardless of sprite origin.
			// It uses the idle sprite as a stable reference for width and bounding box.
			var stable_sprite_for_check = sOrchydeIdle;
			var sprite_x_offset = sprite_get_xoffset(stable_sprite_for_check);
			var bbox_left_relative = sprite_get_bbox_left(stable_sprite_for_check) - sprite_x_offset;
			var bbox_right_relative = sprite_get_bbox_right(stable_sprite_for_check) - sprite_x_offset;
			
			var check_x = inst.x;
			if (move_dir == 1) {
				check_x += bbox_right_relative + 2; // Check 2px past the right edge
			} else {
				check_x += bbox_left_relative - 2; // Check 2px past the left edge
			}
			
			if (!position_meeting(check_x, inst.bbox_bottom + 1, obj_floor)) {
				should_move = false; // Ledge detected!
			}
			
			// Set input based on the stable and accurate decision
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
			// ADDED THIS LINE: Start the cooldown
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