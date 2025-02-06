//Step Event for obj_movement_system
with(all) {
    if (!variable_instance_exists(id, "creature")) continue;
    
    var _move = 0;
    if (creature.state != PlayerState.KNOCKBACK) {  // Only process normal movement if not in knockback
        if (creature.input.right) _move = creature.stats.move_speed;
        if (creature.input.left) _move = -creature.stats.move_speed;
        creature.xsp = _move;

        // Update facing direction only when moving
        if (creature.input.right) creature.facing_direction = "right";
        if (creature.input.left) creature.facing_direction = "left";
    }
    
    // Horizontal collision
    if (place_meeting(x + creature.xsp, y, obj_floor)) {
        while (!place_meeting(x + sign(creature.xsp), y, obj_floor)) {
            x += sign(creature.xsp);
        }
        creature.xsp = 0;
        if (creature.state == PlayerState.KNOCKBACK) {
            creature.state = PlayerState.NORMAL;  // End knockback when hitting a wall
        }
    }
    x += creature.xsp;
    
    var _grounded = place_meeting(x, y + 1, obj_floor);
    
    switch (creature.state) {
        case PlayerState.KNOCKBACK:
            // Apply gravity but maintain horizontal momentum
            creature.ysp += GRAVITY;
            if (_grounded) {
                creature.state = PlayerState.NORMAL;
                creature.xsp = 0;
                creature.ysp = 0;
            }
            break;
            
        case PlayerState.NORMAL:
            if (_grounded && creature.input.jump) {
                creature.state = PlayerState.JUMP_SQUAT;
                creature.jump_squat_timer = JUMP_SQUAT_FRAMES;
                creature.ysp = 0;
                creature.jump_released = false;
            } else if (!_grounded && creature.input.jump && creature.has_jetpack && creature.jetpack_fuel > 0 && creature.jump_released) {
                creature.ysp = max(creature.ysp + JETPACK_FORCE, JETPACK_MAX_SPEED);
                creature.jetpack_fuel--;
            }
            break;
            
        case PlayerState.JUMP_SQUAT:
            creature.jump_squat_timer--;
            if (creature.jump_squat_timer <= 0) {
                creature.state = PlayerState.JUMPING;
                creature.ysp = JUMP_FORCE;
                creature.jump_timer = 0;
            }
            break;
            
        case PlayerState.JUMPING:
            if (creature.jump_timer >= MIN_JUMP_FRAMES) {
                if (!creature.input.jump) {
                    creature.ysp *= JUMP_RELEASE_MULTIPLIER;
                    creature.state = PlayerState.NORMAL;
                    creature.jump_released = true;
                }
            }
            if (creature.input.jump && creature.has_jetpack && creature.jetpack_fuel > 0 && creature.jump_released) {
                creature.ysp = max(creature.ysp + JETPACK_FORCE, JETPACK_MAX_SPEED);
                creature.jetpack_fuel--;
            }
            creature.jump_timer++;
            break;
    }
    
    if (!creature.input.jump) {
        creature.jump_released = true;
    }
    
    // Only apply normal gravity if not in knockback
    if (creature.state != PlayerState.KNOCKBACK) {
        if (!_grounded) {
            creature.ysp += GRAVITY;
            if (creature.ysp > MAX_FALL_SPEED) creature.ysp = MAX_FALL_SPEED;
        } else if (creature.state == PlayerState.NORMAL) {
            creature.ysp = 0;
        }
    }
    
    if (place_meeting(x, y + creature.ysp, obj_floor)) {
        while (!place_meeting(x, y + sign(creature.ysp), obj_floor)) {
            y += sign(creature.ysp);
        }
        creature.ysp = 0;
        if (!_grounded && creature.state != PlayerState.KNOCKBACK) creature.state = PlayerState.NORMAL;
    }
    y += creature.ysp;
}