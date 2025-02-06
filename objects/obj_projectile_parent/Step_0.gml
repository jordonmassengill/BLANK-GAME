// obj_projectile_parent Step Event
// Check if projectile should be destroyed
if (projectile.update() || place_meeting(x, y, obj_floor)) {
    instance_destroy();
    exit;
}
// Update actual sprite position
x += lengthdir_x(projectile.speed, direction);
y += lengthdir_y(projectile.speed, direction);

// obj_projectile_parent Outside Room Event
instance_destroy();