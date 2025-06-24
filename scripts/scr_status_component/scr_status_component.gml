// In scr_status_component.gml

/// @function create_status_component(owner_entity)
/// @description Manages active status effects on an entity by reading from global definitions.
function create_status_component(owner_entity) {
    return {
        owner: owner_entity,
        active_effects: ds_map_create(),

        add_effect: function(status_id, source_entity) {
			            show_debug_message("ATTEMPTING TO ADD EFFECT: " + string(status_id) + " TO " + object_get_name(self.owner.owner_instance.object_index));

            var definition = global.StatusDefinitions[status_id];
            
            if (ds_map_exists(self.active_effects, status_id)) {
                var active_effect = self.active_effects[? status_id];
                active_effect.stacks = min(active_effect.stacks + 1, definition.max_stacks);
                active_effect.duration = definition.duration;
            } else {
                var new_effect = {
                    definition: definition,
                    duration: definition.duration,
                    tick_timer: 0,
                    stacks: 1,
                    source: source_entity
                };
                ds_map_add(self.active_effects, status_id, new_effect);
            }
        },

        update: function() {
            var keys = ds_map_keys_to_array(self.active_effects);
            for (var i = 0; i < array_length(keys); i++) {
                var key = keys[i];
                if (!ds_map_exists(self.active_effects, key)) continue;

                var effect = self.active_effects[? key];
                
                effect.duration--;
                if (effect.duration <= 0) {
                    ds_map_delete(self.active_effects, key);
                    continue; 
                }
                
                if (effect.definition.tick_rate > 0) {
                    effect.tick_timer++;
                    if (effect.tick_timer >= effect.definition.tick_rate) {
                        effect.tick_timer = 0;
                        self.process_tick(effect);
                    }
                }
            }
        },
        
        process_tick: function(effect) {
            // Loop through the modifiers in the blueprint (e.g., Burn has a "periodic_damage" modifier)
            for (var i = 0; i < array_length(effect.definition.modifiers); i++) {
                var modifier = effect.definition.modifiers[i];
                
                if (modifier.type == "periodic_damage") {
                    var final_dot_damage = calculate_damage(
                        modifier.value,
                        modifier.damage_type,
                        self.owner.owner_instance,
                        modifier.element,
                        effect.source
                    );
                    
                    if (self.owner.has_component("health")) {
                        self.owner.health.take_damage(final_dot_damage); 
                    }
                }
            }
        },
        
        has_flag: function(flag_name) {
            return false;
        },

        get_stat_modifiers: function(stat_to_check) {
            var modifiers = { additive: 0, multiplicative: 1.0 };
            return modifiers;
        },
        
        cleanup: function() {
            ds_map_destroy(self.active_effects);
        }
    };
}