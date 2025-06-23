/// @description Status Component System - Manages status effects on an entity.

/// @function create_status_component(owner_entity)
/// @description The main constructor for the status component. An instance of this will be attached to each creature.
/// @param {struct} owner_entity A reference to the entity this component belongs to.
function create_status_component(owner_entity) {
	return {
		//======================================================================
		// PROPERTIES
		//======================================================================
		owner: owner_entity,           // A reference to the entity this component belongs to.
		active_effects: ds_list_create(), // A list to hold all current status effects.

		//======================================================================
		// METHODS
		//======================================================================

		/// @function init()
		/// @description Initializes the component. Called automatically by the component system.
		init: function() {
			// This is here for future expansion if needed.
			return self;
		},

		/// @function add_effect(effect_type, magnitude, duration, tick_rate)
		/// @description Adds a new status effect or refreshes an existing one.
		add_effect: function(effect_type, magnitude, duration, tick_rate = 0) {
			// Check if an effect of the same type already exists.
			for (var i = 0; i < ds_list_size(self.active_effects); i++) {
				var effect = self.active_effects[| i];
				if (effect.type == effect_type) {
					// If it exists, refresh its duration and apply the strongest magnitude.
					effect.duration = duration;
					effect.magnitude = max(effect.magnitude, magnitude);
					return; // Exit, we're done.
				}
			}
			// If no existing effect was found, add a new one to the list.
			ds_list_add(self.active_effects, create_effect(effect_type, magnitude, duration, tick_rate));
		},

		/// @function update()
		/// @description The main logic loop, called every frame from the owner's Step event.
		update: function() {

	    // First, check if the owner instance still exists. This is a safety measure.
	    if (!instance_exists(self.owner.owner_instance)) {
	        return;
	    }

	    // Get direct references to other components and structs for easier access
	    var movement_comp = self.owner.movement;
	    var health_comp = self.owner.health;
	    var stats = self.owner.owner_instance.creature.stats;
	    var input = self.owner.owner_instance.creature.input;

	    // --- Reset all temporary modifications at the start of the frame ---
	    // This prevents effects from getting "stuck" after they expire.
	    if (movement_comp != undefined) {
	        // We use the movement component's own method to control speed.
	        movement_comp.set_speed_multiplier(1.0);
	    }
	    if (stats != undefined) {
	        // This replicates the old system for slowing attack speed.
	        stats.rof_bonus = 0;
	    }

	    // --- Loop through active effects and apply their logic ---
	    var i = 0;
	    while (i < ds_list_size(self.active_effects)) {
	        var effect = self.active_effects[| i];

	        // Apply the logic based on the effect's type
	        switch (effect.type) {
	            case STATUS_TYPE.MOVEMENT_SLOW:
	                if (movement_comp != undefined) {
	                    movement_comp.set_speed_multiplier(max(0.1, 1.0 - effect.magnitude));
	                }
	                break;

	            case STATUS_TYPE.ATTACK_SLOW:
	                if (stats != undefined) {
	                    stats.rof_bonus = -(stats.rate_of_fire * effect.magnitude);
	                }
	                break;

	            case STATUS_TYPE.STUN:
	                if (input != undefined) {
	                    // Directly disable creature input.
	                    input.left = false;
	                    input.right = false;
	                    input.jump = false;
	                    input.fire = false;
	                    input.alt_fire = false;
	                }
	                break;

	            case STATUS_TYPE.DOT: // Damage Over Time
	                effect.current_tick++;
	                if (effect.current_tick >= effect.tick_rate) {
	                    effect.current_tick = 0;
	                    if (health_comp != undefined) {
	                        // Directly damage the health component.
	                        health_comp.take_damage(effect.magnitude);
	                    }
	                }
	                break;
	        }

	        // Decrement the effect's duration and remove it if it has expired.
	        effect.duration--;
	        if (effect.duration <= 0) {
	            ds_list_delete(self.active_effects, i);
	            // Do not increment 'i' here, because the list shifts after deletion.
	        } else {
	            i++; // Only increment 'i' if we didn't delete the element.
	        }
	    }
	},

		/// @function get_effect_magnitude(effect_type)
		/// @description Returns the strength of a specific status effect, or 0 if not active.
		get_effect_magnitude: function(effect_type) {
			for (var i = 0; i < ds_list_size(self.active_effects); i++) {
				var effect = self.active_effects[| i];
				if (effect.type == effect_type) {
					return effect.magnitude;
				}
			}
			return 0;
		},

		/// @function has_effect(effect_type)
		/// @description Checks if a specific status effect is currently active.
		has_effect: function(effect_type) {
			for (var i = 0; i < ds_list_size(self.active_effects); i++) {
				var effect = self.active_effects[| i];
				if (effect.type == effect_type) {
					return true;
				}
			}
			return false;
		},

		/// @function cleanup()
		/// @description Frees the memory used by the ds_list when the owner is destroyed.
		cleanup: function() {
			ds_list_destroy(self.active_effects);
		}

	}.init(); // Call init() immediately upon creation.
}