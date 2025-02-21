// scr_damage_types

enum DAMAGE_TYPE {
    PHYSICAL,
    MAGICAL,
    DOT,    
    AOE     
}

function create_projectile_properties(base_damage, damage_type, element_type) {
    return {
        base_damage: base_damage,
        damage_type: damage_type,
        element_type: element_type,
        
        dot_damage: 0,
        dot_duration: 0,
        dot_tick_rate: 60,
        movement_slow: 0,
        fire_rate_slow: 0,
        stun_duration: 0,
        armor_pierce: 0
    };
}

function calculate_damage(amount, damage_type, target, element_type, attacker) {
    show_debug_message("=== DAMAGE CALCULATION START ===");
    show_debug_message("Base amount: " + string(amount));
    show_debug_message("Damage type: " + string(damage_type));
    
    var final_damage = amount;
    var armor = target.creature.stats.get_armor();
    var crit_mult = 1.0;
    var damage_level = 1;
    var damage_bonus = 1;
    var armor_reduction = 1;
    
    show_debug_message("Target armor: " + string(armor));
    
    if (variable_instance_exists(attacker, "creature")) {
        if (variable_instance_exists(attacker, "is_crit")) {
            if (attacker.is_crit) {
                crit_mult = attacker.creature.stats.get_crit_multiplier();
                show_debug_message("Crit applied! Multiplier: " + string(crit_mult));
            }
        }
        
        switch(damage_type) {
            case DAMAGE_TYPE.PHYSICAL:
                damage_level = attacker.creature.stats.get_physical_damage();
                damage_bonus = 1 + ((damage_level - 1) * 0.2);
                
                // First apply crit
                final_damage = amount * crit_mult;
                
                // Then multiply by physical bonus
                final_damage *= damage_bonus;
                
                armor_reduction = (1 - (armor / 100));
                break;
                
            case DAMAGE_TYPE.MAGICAL:
                damage_level = attacker.creature.stats.get_magical_damage();
                damage_bonus = 1 + ((damage_level - 1) * 0.2);
                
                // First apply crit
                final_damage = amount * crit_mult;
                
                // Then multiply by magical bonus
                final_damage *= damage_bonus;
                
                armor_reduction = (1 - (armor / 100));
                break;
                
            case DAMAGE_TYPE.DOT:
                armor_reduction = (1 - (armor / 150));
                break;
                
            case DAMAGE_TYPE.AOE:
			    damage_level = attacker.creature.stats.get_aoe_damage();
                damage_bonus = 1 + ((damage_level - 1) * 0.5);
                
                // First apply crit
                final_damage = amount * crit_mult;
                
                // Then multiply by physical bonus
                final_damage *= damage_bonus;
                armor_reduction = (1 - (armor / 50));
                break;
        }
        
        // Apply armor reduction
        final_damage *= armor_reduction;
        
        // Round to 2 decimal places
        final_damage = round(final_damage * 100) / 100;
    }
    
    return final_damage;
}