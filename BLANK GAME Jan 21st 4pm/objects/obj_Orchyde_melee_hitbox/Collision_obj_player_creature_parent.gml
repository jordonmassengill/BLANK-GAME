//obj_Orchyde_melee_hitbox Collision Event with obj_player_creature_parent
if (!has_hit && other.id != creator) {
    show_debug_message("Hitbox collision with player!");
    has_hit = true;
    
    // Apply damage
    global.health_system.damage_creature(other, damage);
    
    // Calculate knockback direction
    var knock_dir = point_direction(creator.x, creator.y, other.x, other.y);
    
    // Apply knockback to player's creature properties
    if (variable_instance_exists(other, "creature")) {
        // Set to knockback state
        other.creature.state = PlayerState.KNOCKBACK;
        
        // Apply stronger knockback
        var knock_h = lengthdir_x(knockback_force, knock_dir);
        var knock_v = lengthdir_y(knockback_force * 2, knock_dir);
        
        // Ensure minimum vertical knockback for better feel
        if (knock_v > -2) knock_v = -2;
        
        other.creature.xsp = knock_h;
        other.creature.ysp = knock_v;
        
        show_debug_message("Applied knockback: " + string(knockback_force));
        show_debug_message("Knockback direction: " + string(knock_dir));
        show_debug_message("X Speed: " + string(knock_h));
        show_debug_message("Y Speed: " + string(knock_v));
    }
    
    instance_destroy();
}