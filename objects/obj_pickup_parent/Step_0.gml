// obj_pickup_parent Step Event - REVISED with robust collision

// --- Defensive Initialization ---
if (!variable_instance_exists(id, "pickup_cooldown")) {
    pickup_cooldown = 0;
    vspeed = 0;
    hspeed = 0;
    gravity = 0.08;
}

// --- Cooldown Logic ---
if (pickup_cooldown > 0) {
    pickup_cooldown--;
}

// --- Physics and Floor Collision Logic ---
// 1. Apply Gravity only if not on the floor
if (!place_meeting(x, y + 1, obj_floor)) {
    vspeed += gravity;
}

// 2. Horizontal Movement
if (hspeed != 0) {
    if (place_meeting(x + hspeed, y, obj_floor)) {
        while(!place_meeting(x + sign(hspeed), y, obj_floor)) { x += sign(hspeed); }
        hspeed = 0;
    }
    x += hspeed;
}

// 3. Vertical Movement (NEW BULLETPROOF LOGIC)
// This new loop moves the object one pixel at a time for its total
// vertical speed. This makes it impossible to tunnel through the floor.
for (var i = 0; i < abs(vspeed); i++) {
    if (place_meeting(x, y + sign(vspeed), obj_floor)) {
        vspeed = 0; // Stop immediately upon collision
        break;      // Exit the loop
    }
    // If no collision, move one pixel
    y += sign(vspeed);
}


// --- Pickup Logic ---
if (pickup_cooldown <= 0) {
    var hit_list = ds_list_create();
    var hit_num = instance_place_list(x, y, obj_player_creature_parent, hit_list, false);
    
    if (hit_num > 0) {
        var player_collider = hit_list[| 0];
        if (apply_effect(player_collider)) {
            instance_destroy();
        }
    }
    ds_list_destroy(hit_list);
}
