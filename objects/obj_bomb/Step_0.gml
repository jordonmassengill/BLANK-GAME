// obj_bomb Step Event
if (has_exploded || is_exploding) exit;
    
// Update position
x += lengthdir_x(projectile.speed, direction);
y += vspeed;
vspeed += gravity;

// Only check for floor collisions, let the collision events handle NPCs/enemies
if (place_meeting(x, y, obj_floor)) {
    create_explosion();
    exit;
}

// Also explode if lifetime runs out
if (projectile.update()) {
    create_explosion();
}