// scr_status_system

enum STATUS_TYPE {
    DOT,
    MOVEMENT_SLOW,
    ATTACK_SLOW,
    STUN,
    ARMOR_PIERCE
}

/// @function create_status_manager()
/// @description Creates a status manager to handle status effects
/// @returns {struct} A status manager struct
function create_status_manager() {
    return {
        active_effects: ds_list_create(),
        
        add_effect: function(effect_type, magnitude, duration, tick_rate = 0, element_type = undefined) {
            // Find existing effect of same type and element
            var existing_index = -1;
            for(var i = 0; i < ds_list_size(active_effects); i++) {
                var effect = ds_list_find_value(active_effects, i);
                if(effect.type == effect_type && 
                   (!variable_struct_exists(effect, "element_type") || 
                    effect.element_type == element_type)) {
                    existing_index = i;
                    break;
                }
            }
            
            if (existing_index != -1) {
                var existing = ds_list_find_value(active_effects, existing_index);
                // For all effects: take highest magnitude and refresh duration
                existing.magnitude = max(existing.magnitude, magnitude);
                existing.duration = duration; // Reset duration
            } else {
                ds_list_add(active_effects, create_effect(effect_type, magnitude, duration, tick_rate, element_type));
            }
        },
        
        update_effects: function(target) {
            var i = 0;
            while (i < ds_list_size(active_effects)) {
                var effect = ds_list_find_value(active_effects, i);
                
                // Handle ticking effects (like DOT)
                if (effect.tick_rate > 0) {
                    effect.current_tick++;
                    
                    if (effect.current_tick >= effect.tick_rate) {
                        effect.current_tick = 0;
                        
                        if (effect.type == STATUS_TYPE.DOT) {
                            // Apply DOT damage via component
                            if (variable_instance_exists(target, "entity") && 
                                variable_struct_exists(target.entity, "health")) {
                                
                                target.entity.health.take_damage(effect.magnitude);
										if (!instance_exists(target)) {
										return;
									}
                                
                                if (variable_global_exists("damage_number_system")) {
                                    global.damage_number_system.add_number(target, effect.magnitude, false);
                                }
                            }
                        }
                    }
                }
                
                effect.duration--;
                if (effect.duration <= 0) {
                    ds_list_delete(active_effects, i);
                } else {
                    i++;
                }
            }
        },
        
        get_effect_magnitude: function(effect_type) {
            for(var i = 0; i < ds_list_size(active_effects); i++) {
                var effect = ds_list_find_value(active_effects, i);
                if(effect.type == effect_type) {
                    return effect.magnitude;
                }
            }
            return 0;
        },
        
        has_effect: function(effect_type) {
            for(var i = 0; i < ds_list_size(active_effects); i++) {
                var effect = ds_list_find_value(active_effects, i);
                if(effect.type == effect_type) {
                    return true;
                }
            }
            return false;
        },
        
        cleanup: function() {
            ds_list_destroy(active_effects);
        },
        
        clear_effects: function() {
            ds_list_clear(active_effects);
        }
    };
}

/// @function create_effect(type, magnitude, duration, tick_rate, element_type)
/// @description Creates a status effect struct
/// @param {constant} type - The type of effect from STATUS_TYPE enum
/// @param {real} magnitude - How strong the effect is
/// @param {real} duration - How many steps the effect lasts
/// @param {real} tick_rate - How many steps between effect ticks (for DOT)
/// @param {constant} element_type - Optional, the element type causing this effect
/// @returns {struct} A status effect struct
function create_effect(type, magnitude, duration, tick_rate = 0, element_type = undefined) {
    return {
        type: type,
        magnitude: magnitude,
        duration: duration,
        tick_rate: tick_rate,
        current_tick: 0,
        element_type: element_type
    };
}