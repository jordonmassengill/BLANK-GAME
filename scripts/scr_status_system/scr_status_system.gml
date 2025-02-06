// scr_status_system

enum STATUS_TYPE {
    DOT,
    MOVEMENT_SLOW,
    ATTACK_SLOW,
    STUN,
    ARMOR_PIERCE
}

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
        
        update_effects: function(target) {  // THIS IS THE FUNCTION WE'RE UPDATING
            
            var i = 0;
            while (i < ds_list_size(active_effects)) {
                var effect = ds_list_find_value(active_effects, i);
                
                // Handle ticking effects (like DOT)
                if (effect.tick_rate > 0) {
                    effect.current_tick++;
                    
                    if (effect.current_tick >= effect.tick_rate) {
                        effect.current_tick = 0;
                        
                        if (effect.type == STATUS_TYPE.DOT) {
                            if (variable_global_exists("damage_number_system")) {
                                global.damage_number_system.add_number(target.id, effect.magnitude, false);
                            }
                            target.creature.current_health -= effect.magnitude;
                        }
                    }
                }
                
                effect.duration--;
                if (effect.duration <= 0) {
                    show_debug_message("Effect expired, removing");
                    ds_list_delete(active_effects, i);
                } else {
                    i++;
                }
            }
        },
        
        get_effect_magnitude: function(effect_type) {
            for(var i = 0; i < ds_list_size(active_effects); i++) {
                var effect = ds_list_find_value(active_effects, i);  // Changed to GML function
                if(effect.type == effect_type) {
                    return effect.magnitude;
                }
            }
            return 0;
        },
        
        has_effect: function(effect_type) {
            for(var i = 0; i < ds_list_size(active_effects); i++) {
                var effect = ds_list_find_value(active_effects, i);  // Changed to GML function
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