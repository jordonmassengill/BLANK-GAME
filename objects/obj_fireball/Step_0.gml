// obj_fireball Step Event
if (projectile.update() || place_meeting(x, y, obj_floor)) {
    instance_destroy();
    exit;
}

// Update actual sprite position using GameMaker's built-in variables
x += lengthdir_x(projectile.speed, direction);
y += lengthdir_y(projectile.speed, direction);