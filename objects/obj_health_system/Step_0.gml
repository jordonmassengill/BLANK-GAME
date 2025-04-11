// obj_health_system Step Event
with(all) {
    // Skip objects without creature property or entity
    if (!variable_instance_exists(id, "creature") ||
        !variable_instance_exists(id, "entity") ||
        !variable_struct_exists(entity, "health")) continue;
    
    // Apply health regeneration
    if (variable_struct_exists(creature, "stats") && 
        variable_struct_exists(creature.stats, "health_regen") && 
        creature.stats.health_regen > 0) {
        
        var regen_amount = creature.stats.health_regen / 60; // convert per second to per step
        entity.health.heal(regen_amount);
    }
    
    // IMPORTANT: Removing the direct collision damage code that was causing 
    // 50 damage per step when touching enemies
    // Instead, we'll add a small invulnerability timer to prevent rapid damage
    
    if (variable_instance_exists(id, "is_player")) {
        // Check if player has invulnerability timer property
        if (!variable_instance_exists(id, "damage_cooldown")) {
            id.damage_cooldown = 0;
        }
        
        // Decrement cooldown if active
        if (id.damage_cooldown > 0) {
            id.damage_cooldown--;
        }
        
        // Only check collisions if not in cooldown
        if (id.damage_cooldown <= 0) {
            var collided_creature = instance_place(x, y, obj_enemy_parent);
            if (collided_creature != noone) {
                // Apply reasonable contact damage (10 instead of 50)
                entity.health.take_damage(10);
                
                // Start cooldown (30 frames = 0.5 seconds)
                id.damage_cooldown = 30;
                
                // Apply knockback effect if possible
                if (variable_struct_exists(creature, "state_machine") && 
                    creature.state_machine.has_state("KNOCKBACK")) {
                    
                    // Calculate knockback direction (away from enemy)
                    var kb_dir = point_direction(collided_creature.x, collided_creature.y, x, y);
                    
                    // Set velocities for knockback
                    creature.xsp = lengthdir_x(3, kb_dir);  // 3 = knockback strength
                    creature.ysp = min(-2, lengthdir_y(3, kb_dir));  // Ensure some upward movement
                    
                    // Change to knockback state
                    creature.state_machine.change_state("KNOCKBACK");
                }
            }
        }
    }
    
    // Check if health reaches 0
    if (entity.health.current_health <= 0) {
        if (variable_instance_exists(id, "is_player") && 
            variable_struct_exists(creature, "die")) {
            creature.die();  // Call the creature's die function
        }
    }
}