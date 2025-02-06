// obj_guy Step Event
event_inherited();

// This should be in obj_guy's Step Event
if (creature.current_health <= 0) {
    // Create death effect
    var death_effect = instance_create_layer(x, y, "Instances", obj_HeroDeath);
    death_effect.sprite_index = sHeroDeath;
    death_effect.image_xscale = sprite_direction;
    
    // Create death screen
    instance_create_layer(0, 0, "Instances", obj_death_screen);
    
    creature.status_manager.clear_effects();
    instance_destroy();
    exit;
}

// Handle hit timer
if (hit_timer > 0) hit_timer--;

// Check if we're on the ground
is_grounded = place_meeting(x, y + 1, obj_floor);

// Handle animation state
var is_moving = creature.input.left || creature.input.right;

// Update sprite direction
if (creature.input.left) sprite_direction = -1;
if (creature.input.right) sprite_direction = 1;

// Determine animation state based on player state and vertical speed
if (creature.state == PlayerState.JUMPING || !is_grounded) {
    // Check if jetpack is being used, regardless of vertical speed
    if (creature.has_jetpack && creature.jetpack_fuel > 0 && creature.jump_released && creature.input.jump) {
        anim_state = "jetpack";
        jetpack_active = true;
        image_speed = 1;
        fall_animation_started = false;  // Reset falling animation when jetpack activates
    } else if (creature.ysp < 0) {
        anim_state = "jumping";
        jetpack_active = false;
        image_speed = 1;
        fall_animation_started = false;  // Reset falling animation when jumping
    } else {
        jetpack_active = false;
        if (!fall_animation_started) {
            anim_state = "falling";
            image_speed = 1;
            image_index = 0;
            fall_animation_started = true;
        }
    }
} else if (creature.state == PlayerState.JUMP_SQUAT) {
    anim_state = "jumping";
    jetpack_active = false;
    image_speed = 1;
    fall_animation_started = false;
} else {
    // On the ground
    jetpack_active = false;
    fall_animation_started = false;  // Reset falling animation when landing
    
    if (is_moving) {
        anim_blend = min(anim_blend + 0.2, 1);
        anim_state = "running";
        image_speed = 1;
    } else {
        anim_blend = max(anim_blend - 0.25, 0);
        if (anim_blend == 0) {
            anim_state = "idle";
            image_speed = 1;
        }
    }
}