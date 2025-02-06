// obj_guy Draw Event
// Save the current scale
var original_xscale = image_xscale;
// Apply direction flip
image_xscale = sprite_direction * abs(image_xscale);

// Update animation state based on current state
if (hit_timer > 0) {
    sprite_index = sHeroHit;
    image_speed = 1;
} else {
    // Choose sprite based on state
    switch(anim_state) {
        case "idle":
            sprite_index = sHeroIdle;
            break;
        case "running":
            sprite_index = sHeroRun;
            break;
        case "jumping":
            sprite_index = sHeroJump;
            break;
        case "jetpack":
            sprite_index = sHeroJetpack;
            break;
        case "falling":
            sprite_index = sHeroFall;
            if (fall_start) {
                fall_frame_timer += 1;
                if (fall_frame_timer <= 5) {
                    image_index = 0;
                } else if (fall_frame_timer <= 10) {
                    image_index = 1;
                } else {
                    fall_start = false;
                    fall_frame_timer = 0;
                }
            } else {
                fall_frame_timer += 1;
                if (fall_frame_timer <= 5) {
                    image_index = 2;
                } else if (fall_frame_timer <= 10) {
                    image_index = 3;
                } else if (fall_frame_timer <= 15) {
                    image_index = 4;
                } else if (fall_frame_timer <= 20) {
                    image_index = 5;
                } else {
                    fall_frame_timer = 0;
                }
            }
            break;
    }
}

// Draw the sprite
draw_self();

// Reset scale to avoid affecting other objects
image_xscale = original_xscale;

// Draw health bar
if (variable_instance_exists(id, "creature")) {
    global.health_system.draw_health_bar(id);
}