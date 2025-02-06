// obj_guy Create Event (parent = obj_player_creature_parent)
creature = create_player_properties();
is_main_player = true;  // This flag tells the player_manager to follow this player with the camera
// Animation variables
anim_state = "idle";
sprite_direction = 1;  // 1 for right, -1 for left
anim_blend = 0;  // 0 = idle, 1 = full running
image_speed = 1;
is_grounded = true;
// New falling animation variables
fall_start = true;  // Controls if we're in the initial falling frames
fall_frame_timer = 0;  // Used to control frame timing
jetpack_active = false;  // Tracks if jetpack is currently firing
fall_animation_started = false; 

// Add hit animation variables
hit_timer = 0;
hit_timer_max = 15;

// Add hit function
hit = function() {
    if (hit_timer <= 0) {
        hit_timer = hit_timer_max;
        sprite_index = sHeroHit;
        image_index = 0;
        image_speed = 1;
        // Briefly stop movement when hit
        creature.input.left = false;
        creature.input.right = false;
    }
}
