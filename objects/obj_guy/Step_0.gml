// obj_guy Step Event (parent = obj_player_creature_parent)
event_inherited();

// Update state machine
creature.state_machine.update();

// Simple ground check - MOVED UP from below to avoid using is_grounded before initialization
is_grounded = place_meeting(x, y + 1, obj_floor);

// Check if we're in KNOCKBACK state and should transition out
if (creature.state_machine.is_in_state("KNOCKBACK")) {
    if (is_grounded) {
        // Reset velocities
        creature.xsp = 0;
        creature.ysp = 0;
        creature.jump_released = true;
        
        // Transition to appropriate state
        if (creature.input.left || creature.input.right) {
            creature.state_machine.change_state("MOVE");
        } else {
            creature.state_machine.change_state("IDLE");
        }
    }
}

// Update entity
entity.health.update(1/60);

// Sync regeneration rate from creature stats
entity.health.regen_rate = creature.stats.health_regen;

// Handle hit timer
if (hit_timer > 0) hit_timer--;

// Track previous grounded state
var was_grounded = is_grounded;

// Debug visuals for ground check
if (global.debug_visible) {
    draw_set_color(is_grounded ? c_green : c_red);
    draw_line(x - 10, y + sprite_height/2 + 1, x + 10, y + sprite_height/2 + 1);
    draw_set_color(c_white);
}

// Set edge falling flag when appropriate
if (was_grounded && !is_grounded && 
    (creature.state_machine.is_in_state("IDLE") || creature.state_machine.is_in_state("MOVE"))) {
    // Walking off edge detected
    creature.falling_from_edge = true;
    creature.state_machine.change_state("FALL");
} else if (creature.state_machine.is_in_state("JUMP")) {
    // If jumping, we're definitely not falling from an edge
    creature.falling_from_edge = false;
}

// Other state transitions
if (creature.input.jump && is_grounded && creature.jump_released &&
    (creature.state_machine.is_in_state("IDLE") || creature.state_machine.is_in_state("MOVE"))) {
    creature.falling_from_edge = false; // Not falling from edge when jumping
    creature.state_machine.change_state("JUMP_SQUAT");
}

// Transition to FALL if in MOVE but not on ground (not handled by edge detection)
if (!is_grounded && creature.state_machine.is_in_state("MOVE") && !creature.falling_from_edge) {
    creature.state_machine.change_state("FALL");
}

// Land from falling
if (is_grounded && creature.state_machine.is_in_state("FALL")) {
    creature.falling_from_edge = false; // Reset flag when landing
    if (abs(creature.xsp) > 0.1) {
        creature.state_machine.change_state("MOVE");
    } else {
        creature.state_machine.change_state("IDLE");
    }
}

// Update facing direction based on input
if (creature.input.left) creature.facing_direction = "left";
if (creature.input.right) creature.facing_direction = "right";

// Update sprite direction based on facing direction
sprite_direction = (creature.facing_direction == "right") ? 1 : -1;

// Define is_moving variable based on input
var is_moving = creature.input.left || creature.input.right;

// Set animation state based on state machine state
if (hit_timer > 0) {
    anim_state = "hit";
} else if (creature.state_machine.is_in_state("JUMP") || 
          creature.state_machine.is_in_state("FALL")) {
    // Check if jetpack is being used
    if (creature.has_jetpack && creature.jetpack_fuel > 0 && 
        creature.jump_released && creature.input.jump) {
        anim_state = "jetpack";
        jetpack_active = true;
        fall_animation_started = false;
    } else if (creature.ysp < 0) {
        anim_state = "jumping";
        jetpack_active = false;
        fall_animation_started = false;
    } else {
        jetpack_active = false;
        if (!fall_animation_started) {
            anim_state = "falling";
            image_speed = 1;
            image_index = 0;
            fall_animation_started = true;
        }
    }
} else if (creature.state_machine.is_in_state("JUMP_SQUAT")) {
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

// If we're not pressing jump, enable jump released flag
if (!creature.input.jump) {
    creature.jump_released = true;
}

// Test damage - press T to apply damage directly to component
if (keyboard_check_pressed(ord("T"))) {
    entity.health.take_damage(10);
}