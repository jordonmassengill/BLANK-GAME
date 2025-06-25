/// @function apply_life_steal(attacker, damage_dealt)
/// @description Calculates and applies healing to an attacker based on their life steal stat.
function apply_life_steal(attacker, damage_dealt) {
    if (attacker == noone || !instance_exists(attacker)) return;
    
    // Check if the attacker can benefit from life steal
    if (variable_instance_exists(attacker, "creature") && 
        variable_instance_exists(attacker, "entity") && 
        attacker.entity.has_component("health")) {
        
        var life_steal_amount = attacker.creature.stats.get_life_steal();
        
        if (life_steal_amount > 0) {
            var heal_amount = damage_dealt * life_steal_amount;
            attacker.entity.health.heal(heal_amount);
        }
    }
}

// You could add other on-hit trigger functions here in the future,
// like apply_reflect_damage(target, attacker, damage_dealt), etc.