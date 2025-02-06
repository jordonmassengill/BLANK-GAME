// obj_health_system Step Event
with(all) {
    if (!variable_instance_exists(id, "creature")) continue;
    
    // Apply health regeneration
    if (creature.stats.health_regen > 0) {
        var regen_amount = creature.stats.health_regen / 60; // convert per second to per step
        global.health_system.modify_health(id, regen_amount);
    } 
    
    // Check for collisions with other creatures
    var collided_creature = instance_place(x, y, all);
    if (collided_creature != noone) {
        if (variable_instance_exists(id, "is_player") && 
            variable_instance_exists(collided_creature, "creature") &&
            variable_instance_exists(collided_creature, "is_enemy")) {
            
            if (collided_creature.is_enemy) {
                global.health_system.damage_creature(id, 50);
            }
        }
    }
    
    // Check if any creature's health reaches 0
    if (creature.current_health <= 0) {
        if (variable_instance_exists(id, "is_player")) {
            creature.die();  // Call the creature's die function
        } else {
            return;
        }
    }
}