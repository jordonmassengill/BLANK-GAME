// obj_bomb Step Event
if (has_exploded) exit;  // Don't process anything if already exploded
    
// Update position
x += lengthdir_x(projectile.speed, direction);
y += vspeed;
vspeed += gravity;

// Check for various collisions that should trigger explosion
if (place_meeting(x, y, obj_floor) || 
    place_meeting(x, y, obj_enemy_parent) || 
    place_meeting(x, y, obj_npc_parent)) {
    show_debug_message("Bomb collision detected!");
    create_explosion();
    exit;
}

// Also explode if lifetime runs out
if (projectile.update()) {
    show_debug_message("Bomb lifetime ended!");
    create_explosion();
}