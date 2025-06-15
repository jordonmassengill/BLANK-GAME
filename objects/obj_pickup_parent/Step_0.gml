// --- Cooldown Logic ---
pickup_cooldown = max(0, pickup_cooldown - 1);


// --- Physics Logic using a custom 'vert_speed' variable ---
vert_speed += gravity;

if (place_meeting(x, y + vert_speed, obj_floor)) {
    while (!place_meeting(x, y + sign(vert_speed), obj_floor)) {
        y += sign(vert_speed);
    }
    vert_speed = 0;
}
y += vert_speed;


// --- Pickup Logic ---
if (pickup_cooldown <= 0) {
    var player_collider = instance_place(x, y, obj_player_creature_parent);
    if (player_collider != noone) {
        if (apply_effect(player_collider)) {
            instance_destroy();
        }
    }
}