// scr_element_system

enum ELEMENT_TYPE {
    NONE,
    FIRE,
    POISON,
    GHOST,
    ICE,
    WATER,
    ELECTRIC
}

// Get element data
function get_element_data(element_type) {
    switch(element_type) {
        case ELEMENT_TYPE.FIRE:
            return {
                dot_enabled: true,
                dot_damage_mult: 0.3,
                dot_duration: 180,
                dot_tick_rate: 15
            };
            
        case ELEMENT_TYPE.POISON:
            return {
                dot_enabled: true,
                dot_damage_mult: 0.6,
                dot_duration: 600,
                dot_tick_rate: 60
            };
            
        case ELEMENT_TYPE.ICE:
            return {
                movement_slow_enabled: true,
                movement_slow_amount: 0.5,
                effect_duration: 180
            };
            
        case ELEMENT_TYPE.WATER:
            return {
                attack_slow_enabled: true,
                attack_slow_amount: 0.5,
                effect_duration: 180
            };
            
        case ELEMENT_TYPE.ELECTRIC:
            return {
                stun_enabled: true,
                stun_duration: 60
            };
            
        case ELEMENT_TYPE.GHOST:
            return {
                armor_pierce_enabled: true,
                armor_pierce_base: 0.1,
				armor_pierce_per_power: 0.1 
            };
            
        default:
            return {};
    }
}

// Apply element properties to a projectile
function apply_element_properties(proj_props, element_type) {
    var element = get_element_data(element_type);
    
    if (variable_struct_exists(element, "dot_enabled") && element[$ "dot_enabled"]) {
        proj_props[$ "dot_damage"] = proj_props[$ "base_damage"] * element[$ "dot_damage_mult"];
        proj_props[$ "dot_duration"] = element[$ "dot_duration"];
        proj_props[$ "dot_tick_rate"] = element[$ "dot_tick_rate"];
    }
    
    if (variable_struct_exists(element, "movement_slow_enabled") && element[$ "movement_slow_enabled"]) {
        proj_props[$ "movement_slow"] = element[$ "movement_slow_amount"];
        proj_props[$ "dot_duration"] = element[$ "effect_duration"];
    }
    
    if (variable_struct_exists(element, "attack_slow_enabled") && element[$ "attack_slow_enabled"]) {
        proj_props[$ "fire_rate_slow"] = element[$ "attack_slow_amount"];
        proj_props[$ "dot_duration"] = element[$ "effect_duration"];
    }
    
    if (variable_struct_exists(element, "stun_enabled") && element[$ "stun_enabled"]) {
        proj_props[$ "stun_duration"] = element[$ "stun_duration"];
    }
    
    if (variable_struct_exists(element, "armor_pierce_enabled") && element[$ "armor_pierce_enabled"]) {
        proj_props[$ "armor_pierce"] = element[$ "armor_pierce_amount"];
    }
    
    return proj_props;
}

// Replace the entire function with this robust version.
function apply_status_effects(target, proj_props, attacker) {

    // This check is good and confirms the target is valid.
    if (!variable_instance_exists(target, "entity") || !target.entity.has_component("health")) {
        return;
    }

    var elemental_power = 1.0;
    var resistance_multiplier = 1.0; // Default to no resistance

    // Safely get elemental power from the attacker via the component path
    if (variable_instance_exists(attacker, "entity") && attacker.entity.has_component("movement")) {
        elemental_power = attacker.entity.movement.stats.get_elemental_power();
    }

    // Safely get resistance from the target via the component path.
    // This bypasses the buggy "creature" check entirely.
    if (variable_instance_exists(target, "entity") && target.entity.has_component("movement")) {
        resistance_multiplier = 1.0 - (target.entity.movement.stats.get_resistance() / 100);
    }

    // Now, check for the status component and apply the effect.
    if (target.entity.has_component("status")) {
        var status_comp = target.entity.status;

        // Apply DOT effects
        if (proj_props.dot_damage > 0) {
            var final_dot = proj_props.dot_damage * elemental_power * resistance_multiplier;
            var final_duration = proj_props.dot_duration * resistance_multiplier;
            status_comp.add_effect(STATUS_TYPE.DOT, final_dot, final_duration, proj_props.dot_tick_rate);
        }

        // (The rest of the status effect logic for slow, stun, etc. follows...)
        if (proj_props.movement_slow > 0) {
            var final_slow = min(0.9, proj_props.movement_slow * elemental_power * resistance_multiplier);
            var final_duration = proj_props.dot_duration * resistance_multiplier;
            status_comp.add_effect(STATUS_TYPE.MOVEMENT_SLOW, final_slow, final_duration);
        }

        if (proj_props.fire_rate_slow > 0) {
            var final_slow = min(0.9, proj_props.fire_rate_slow * elemental_power * resistance_multiplier);
            var final_duration = proj_props.dot_duration * resistance_multiplier;
            status_comp.add_effect(STATUS_TYPE.ATTACK_SLOW, final_slow, final_duration);
        }

        if (proj_props.stun_duration > 0) {
            var final_duration = proj_props.stun_duration * resistance_multiplier;
            status_comp.add_effect(STATUS_TYPE.STUN, 1.0, final_duration);
        }
    }
}

function calculate_elemental_multiplier(target, element_type, attacker) {
    var multiplier = 1.0;
    
    // Get elemental power from attacker if it exists
    if (variable_instance_exists(attacker, "creature")) {
        multiplier *= attacker.creature.stats.get_elemental_power();
    }
    
    // Apply target's resistance if it exists
    if (variable_instance_exists(target, "creature")) {
        var resistance = target.creature.stats.get_resistance();
        multiplier *= (1 - (resistance / 100));
    }
    
    return multiplier;
}