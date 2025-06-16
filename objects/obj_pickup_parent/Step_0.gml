// --- Cooldown Logic (Bulletproof) ---
// First, check if the cooldown variable exists. If not, create it.
// This makes items placed in the editor work correctly.
if (!variable_instance_exists(id, "pickup_cooldown")) {
    pickup_cooldown = 0;
}

// Count the timer down to 0.
pickup_cooldown = max(0, pickup_cooldown - 1);


// --- Pickup Logic ---
// Only check for a pickup if the cooldown timer has finished.
if (pickup_cooldown <= 0) {
    var player_collider = instance_place(x, y, obj_player_creature_parent);

    if (player_collider != noone) {
        if (apply_effect(player_collider)) {
            instance_destroy();
        }
    }
}