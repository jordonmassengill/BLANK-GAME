/// @function create_movement_component(owner_entity, owner_stats)
/// @description Creates a component to manage all entity movement, physics, and states.
/// @param {struct} owner_entity - The parent entity struct (the one with .owner_instance).
/// @param {struct} owner_stats - The stats struct to read move_speed, etc. from.
function create_movement_component(owner_entity, owner_stats) {
	
	// --- CONFIGURATION ---
	// These values can be tuned to change the feel of the movement.
	var _config = {
		gravity: 0.1,
		max_fall_speed: 4,
		jump_force: -3,
		jump_release_multiplier: 0.5,
		jump_squat_frames: 3, 
		jetpack_force: -0.3,
		jetpack_max_speed: -3.5,
		knockback_stun_frames: 20 
	};

	return {
		// --- PROPERTIES ---
		owner: owner_entity,
		stats: owner_stats,
		input: owner_entity.owner_instance.creature.input,
		xsp: 0,
		ysp: 0,
		state_machine: create_state_machine(),
		config: _config,
		
		// State-tracking variables
		jump_squat_timer: 0,
		jump_timer: 0,
		jump_button_released_in_air: false, // Renamed for clarity
		was_grounded: true,
		is_grounded: true,
		knockback_timer: 0,
		jump_released: true, // NEW: Now managed internally by the component

		// --- METHODS ---

		init: function() {
			self.state_machine.init(self);
			
			// --- STATE DEFINITIONS ---

			self.state_machine.add_state("IDLE",
				function() { self.xsp = 0; },
				function() { if (self.input.left || self.input.right) self.state_machine.change_state("MOVE"); }
			);
			
			self.state_machine.add_state("MOVE",
				function() { },
				function() {
					var move = 0;
					if (self.input.right) move = self.stats.get_move_speed();
					if (self.input.left) move = -self.stats.get_move_speed();
					self.xsp = move;
					if (!self.input.left && !self.input.right) self.state_machine.change_state("IDLE");
				}
			);
			
			self.state_machine.add_state("JUMP_SQUAT",
				function() {
					self.jump_squat_timer = self.config.jump_squat_frames;
					self.ysp = 0;
				},
				function() {
					self.xsp *= 0.98;
					self.jump_squat_timer--;
					if (self.jump_squat_timer <= 0) self.state_machine.change_state("JUMP");
				}
			);
			
			self.state_machine.add_state("JUMP",
				function() {
					self.ysp = self.config.jump_force;
					self.jump_timer = 0;
					self.jump_button_released_in_air = false;
				},
				function() {
					self.ysp += self.config.gravity;
					if (!self.input.jump && !self.jump_button_released_in_air) {
						self.ysp *= self.config.jump_release_multiplier;
						self.jump_button_released_in_air = true;
					}
					var move = 0;
					if (self.input.right) move = self.stats.get_move_speed();
					if (self.input.left) move = -self.stats.get_move_speed();
					self.xsp = move;
					if (self.ysp >= 0) self.state_machine.change_state("FALL");
				}
			);
			
			self.state_machine.add_state("FALL",
				function() { },
				function() {
					self.ysp += self.config.gravity;
					if (self.ysp > self.config.max_fall_speed) self.ysp = self.config.max_fall_speed;
					var move = 0;
					if (self.input.right) move = self.stats.get_move_speed();
					if (self.input.left) move = -self.stats.get_move_speed();
					self.xsp = move;
					if (self.input.jump && self.owner.owner_instance.creature.has_jetpack && self.owner.owner_instance.creature.jetpack_fuel > 0) {
						self.ysp = max(self.ysp + self.config.jetpack_force, self.config.jetpack_max_speed);
						self.owner.owner_instance.creature.jetpack_fuel--;
					}
				}
			);
			
			self.state_machine.add_state("KNOCKBACK",
				function() {
					self.knockback_timer = self.config.knockback_stun_frames;
				},
				function() {
					self.ysp += self.config.gravity;
					self.xsp *= 0.95;
					if (self.knockback_timer > 0) self.knockback_timer--;
					if (self.knockback_timer <= 0) self.state_machine.change_state("FALL");
				}
			);

			// Intelligent Initial State
			var is_on_ground_at_start = false;
			with(self.owner.owner_instance) { is_on_ground_at_start = place_meeting(x, y + 1, obj_floor); }
			if (is_on_ground_at_start) {
				self.is_grounded = true;
				self.was_grounded = true;
				self.state_machine.change_state("IDLE");
			} else {
				self.is_grounded = false;
				self.was_grounded = false;
				self.state_machine.change_state("FALL");
			}
			return self;
		},
		
		set_input_xy: function(x_val, y_val) {
			self.input.left = (x_val < 0);
			self.input.right = (x_val > 0);
			// self.input.jump could be set here in the future for flying/jumping AI
			return self;
		},

		update: function() {
			var inst = self.owner.owner_instance;
			
			// --- FIX: Manage jump_released flag internally ---
			if (!self.input.jump) {
				self.jump_released = true;
			}
			
			with (inst) {
				other.was_grounded = other.is_grounded;
				other.is_grounded = place_meeting(x, y + 1, obj_floor);
			}
			
			if (self.is_grounded && !self.was_grounded) { 
				if (self.state_machine.is_in_state("FALL") || self.state_machine.is_in_state("KNOCKBACK")) {
					self.ysp = 0;
					if (self.input.jump && self.jump_released) {
						self.jump_released = false;
						self.state_machine.change_state("JUMP_SQUAT"); 
					} else if (self.input.left || self.input.right) {
						self.state_machine.change_state("MOVE");
					} else {
						self.state_machine.change_state("IDLE"); 
					}
				}
			} else if (!self.is_grounded && self.was_grounded) {
				if (self.state_machine.is_in_state("IDLE") || self.state_machine.is_in_state("MOVE")) {
					self.state_machine.change_state("FALL");
				}
			}
			
			if (self.input.jump && self.is_grounded && (self.state_machine.is_in_state("IDLE") || self.state_machine.is_in_state("MOVE"))) {
				if (self.jump_released) {
					self.jump_released = false;
					self.state_machine.change_state("JUMP_SQUAT");
				}
			}
			
			self.state_machine.update();
			return self;
		},
		
		apply_knockback: function(h_force, v_force) {
			self.xsp = h_force;
			self.ysp = v_force;
			self.state_machine.change_state("KNOCKBACK");
			return self;
		},
		
		get_anim_state: function() {
			var inst = self.owner.owner_instance;
			var current_sm_state = self.state_machine.get_current_state();
			if(inst.hit_timer > 0) return "hit";
			switch (current_sm_state) {
				case "IDLE":       return "idle";
				case "MOVE":       return "running";
				case "JUMP_SQUAT": return "jumping";
				case "JUMP":       return (self.ysp < 0) ? "jumping" : "falling";
				case "FALL":
					if (self.input.jump && inst.creature.has_jetpack && inst.creature.jetpack_fuel > 0) {
						return "jetpack";
					}
					return "falling";
				case "KNOCKBACK":  return "hit";
				default:           return "idle";
			}
		},
		force_state_re_evaluation: function() {
    var inst = self.owner.owner_instance;

    // Check our physical state right now
    with (inst) {
        self.is_grounded = place_meeting(x, y + 1, obj_floor);
    }

    // Based on our physical state, force the correct state machine state
    if (self.is_grounded) {
        self.state_machine.change_state("IDLE");
        self.ysp = 0; // Cancel any lingering vertical speed
    } else {
        self.state_machine.change_state("FALL");
    }
    
    // Sync up the was_grounded variable to prevent a false landing on the next frame
    self.was_grounded = self.is_grounded;
    return self;
}
	}.init();
}
