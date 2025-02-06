// scr_damage_types

// Damage Type Enum
enum DAMAGE_TYPE {
    PHYSICAL,
    MAGICAL,
    DOT,    // Damage Over Time
    AOE     // Area of Effect
}

// Create base projectile properties with damage type and element
function create_projectile_properties(base_damage, damage_type, element_type) {
    return {
        base_damage: base_damage,
        damage_type: damage_type,
        element_type: element_type,
        
        // Status effect parameters
        dot_damage: 0,
        dot_duration: 0,
        dot_tick_rate: 60,  // Default 1 second between ticks
        movement_slow: 0,
        fire_rate_slow: 0,
        stun_duration: 0,
        armor_pierce: 0
    };
}

function calculate_damage(amount, damage_type, target, element_type, attacker) {
    var final_damage = amount;
    
    // Apply attacker's damage stats based on damage type
    if (variable_instance_exists(attacker, "creature")) {
        switch(damage_type) {
            case DAMAGE_TYPE.PHYSICAL:
                final_damage *= attacker.creature.stats.get_physical_damage();
                break;
            case DAMAGE_TYPE.MAGICAL:
                final_damage *= attacker.creature.stats.get_magical_damage();
                break;
        }
    }
    
    // Get armor value
    var armor = target.creature.stats.get_armor();
    
    // Handle ghost element armor pierce
    if (element_type == ELEMENT_TYPE.GHOST) {
        // Start with base armor pierce (50%)
        var armor_pierce_amount = 0.5;
        
        if (variable_instance_exists(attacker, "creature")) {
            // Add 10% per level of elemental power above 1
            var elemental_power = attacker.creature.stats.get_elemental_power() - 1.0;
            armor_pierce_amount += 0.1 * elemental_power;
        }
        
        // Reduce effectiveness based on target's resistance
        if (variable_instance_exists(target, "creature")) {
            var resistance = target.creature.stats.get_resistance();
            armor_pierce_amount *= (1 - (resistance / 100));
        }
        
        // Cap at 90% armor pierce
        armor_pierce_amount = min(armor_pierce_amount, 0.9);
        
        // Reduce armor effectiveness
        armor *= (1 - armor_pierce_amount);
        
    }
    
    // Apply armor reduction
    switch(damage_type) {
        case DAMAGE_TYPE.PHYSICAL:
        case DAMAGE_TYPE.MAGICAL:
            final_damage *= (1 - (armor / 100));
            break;
        case DAMAGE_TYPE.DOT:
            final_damage *= (1 - (armor / 150));
            break;
        case DAMAGE_TYPE.AOE:
            final_damage *= (1 - (armor / 50));
            break;
    }
    return final_damage;
}