// This ENTIRE block of code should be in the END STEP event.

// --- 1. Lifetime & Movement ---

// Update the projectile's internal timer. If it expires, destroy the projectile.
if (projectile.update()) {
    instance_destroy();
    exit; // Stop running any more code for this frame.
}

// Apply movement based on the projectile's speed and direction.
x += lengthdir_x(projectile.speed, direction);
y += lengthdir_y(projectile.speed, direction);


// --- 2. Collision Detection ---

// First, check for collision with solid ground.
if (place_meeting(x, y, obj_floor)) {
    instance_destroy();
    exit;
}

// Next, check for collision with any creature.
// Because this is now in the End Step event, all bounding boxes are up-to-date.
var hit_list = ds_list_create();
var num_hits = collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_creature_parent, false, true, hit_list, false);

// If the list found one or more potential targets...
if (num_hits > 0) {
    
    // Loop through all the creatures we hit.
    for (var i = 0; i < num_hits; i++) {
        var hit_target = hit_list[| i];

        // Rule #1: A projectile can never hit the creature that fired it.
        if (hit_target != projectile.shooter) {
            
            // Rule #2: Check if the hit is valid based on object types.
            var isValidHit = (projectile.can_hit_player == hit_target.is_player);

            if (isValidHit) {
                // It's a valid hit! Call the universal `on_hit` function.
                projectile.on_hit(hit_target);
                
                // Destroy the projectile.
                instance_destroy();
                
                // Exit the loop since the projectile is gone.
                break; 
            }
        }
    }
}

// Finally, always clean up the list from memory.
ds_list_destroy(hit_list);