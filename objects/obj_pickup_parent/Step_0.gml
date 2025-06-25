// --- Cooldown Logic ---
// The pickup_cooldown is now initialized in the Create Event.

// Count the timer down to 0.
pickup_cooldown = max(0, pickup_cooldown - 1);


// --- Pickup Logic ---
// Only check for a pickup if the cooldown timer has finished.
if (pickup_cooldown <= 0) {
    var player_collider = instance_place(x, y, obj_player_creature_parent);

    if (player_collider != noone) {
        // The apply_effect function is defined in child objects (like obj_jpack)
        // and is expected to exist.
        if (apply_effect(player_collider)) {
            instance_destroy();
        }
    }
}