// scr_creature_properties.gml
function create_creature_properties() {
    var props = {
        // Movement properties
        xsp : 0,
        ysp : 0,
        facing_direction : "right",
        state : PlayerState.NORMAL,
        jump_squat_timer : 0,
        jump_timer : 0,
        jump_released : false,
        // Add this flag
		falling_from_edge: false,
	
	
        // Ability properties
        has_jetpack : false,
        jetpack_fuel : 0,
        has_fireball : false,
        can_shoot_fireball : false,
        fireball_cooldown : 0,
        // Bomb properties
        has_bomb : false,
        can_throw_bomb : false,
        bomb_cooldown : 0,
        //Dart Properties
        has_dart : false,
        can_shoot_dart : false,
        dart_cooldown : 0,
        //Waterball Properties
        has_waterball : false,
        can_shoot_waterball : false,
        waterball_cooldown : 0,
        //Iceball Properties
        has_iceball : false,
        can_shoot_iceball : false,
        iceball_cooldown : 0,
        //Electro Properties
        has_electro : false,
        can_shoot_electro : false,
        electro_cooldown : 0,
        //Ghoststrike Properties
        has_ghoststrike : false,
        can_shoot_ghoststrike: false,
        ghoststrike_cooldown : 0,
        
        // Input properties (useful for both AI and player control)
        input : {},
		
        // Stats
        stats : create_stats(),
        status_manager: create_status_manager(),  // New status system
        
        // Base properties
        can_die : true,
        
        // Add draw_health_bar as a property function
        draw_health_bar : function(instance_id) {
            var health_width = 40;
            var health_height = 4;
            var health_y_offset = -instance_id.sprite_height + 3;
            
            var xx = instance_id.x - health_width/2;
            var yy = instance_id.y + health_y_offset;
            
            // Draw background (empty health bar)
            draw_set_color(c_red);
            draw_rectangle(xx, yy, xx + health_width, yy + health_height, false);
            
            // Draw current health
            var health_percent = current_health / max_health;
            draw_set_color(c_lime);
            draw_rectangle(xx, yy, xx + (health_width * health_percent), yy + health_height, false);
            
            // Draw tick marks for every 50 health
            draw_set_color(c_black);
            for(var i = 50; i < max_health; i += 50) {
                var tick_x = xx + (health_width * (i/max_health));
                draw_line(tick_x, yy, tick_x, yy + health_height);
            }
            
            // Draw border
            draw_set_color(c_black);
            draw_rectangle(xx, yy, xx + health_width, yy + health_height, true);
            
            // Reset draw color
            draw_set_color(c_white);
        }
    };
    
    // Setup input properties
    props.input = {};
    props.input.left = false;
    props.input.right = false;
    props.input.jump = false;
    props.input.fire = false;
    props.input.alt_fire = false;  // For bombs/secondary weapons
    props.input.aim_x = 0;
    props.input.aim_y = 0;
    props.input.target_x = 0;
    props.input.target_y = 0;
    props.input.using_controller = false;
    props.input.pause_pressed = false;    // Add these new input properties
    props.input.menu_up = false;
    props.input.menu_down = false;
    props.input.menu_select = false;
    props.input.menu_back = false;
	
	// Add state machine
	props.state_machine = create_state_machine();
	props.state_machine.init(props);
	setup_basic_states(props);
    
    return props;
}

// setup_basic_states function in scr_creature_properties.gml
function setup_basic_states(creature_props) {
    // IDLE state
    creature_props.state_machine.add_state("IDLE", 
        method(creature_props, function() {
            // On enter idle
            xsp = 0;
        }),
        method(creature_props, function() {
            // Check for movement input to transition to MOVE
            if (input.left || input.right) {
                state_machine.change_state("MOVE");
            }
        })
    );
    
    // MOVE state
    creature_props.state_machine.add_state("MOVE", 
        method(creature_props, function() {
            // On enter move - empty for now
        }),
        method(creature_props, function() {
            // Apply movement based on input
            var _move = 0;
            if (input.right) _move = stats.get_move_speed();
            if (input.left) _move = -stats.get_move_speed();
            xsp = _move;
            
            // Check if we stopped moving
            if (!input.left && !input.right) {
                state_machine.change_state("IDLE");
            }
        })
    );
    
    // JUMP_SQUAT state
    creature_props.state_machine.add_state("JUMP_SQUAT", 
        method(creature_props, function() {
            // Initialize jump squat
            jump_squat_timer = JUMP_SQUAT_FRAMES;
            ysp = 0;
            jump_released = false;
            jump_button_released = false;
        }),
        method(creature_props, function() {
            // Count down jump squat timer
            jump_squat_timer--;
            if (jump_squat_timer <= 0) {
                state_machine.change_state("JUMP");
            }
        })
    );
    
    // JUMP state
    creature_props.state_machine.add_state("JUMP", 
        method(creature_props, function() {
            // Initialize jump
            ysp = JUMP_FORCE;
            jump_timer = 0;
        }),
        method(creature_props, function() {
            // Apply gravity
            ysp += GRAVITY;
            
            // Variable jump height when button released
            if (!input.jump && !jump_button_released) {
                ysp *= JUMP_RELEASE_MULTIPLIER;
                jump_button_released = true;
            }
            
            // Handle horizontal movement in air
            var _move = 0;
            if (input.right) _move = stats.get_move_speed();
            if (input.left) _move = -stats.get_move_speed();
            xsp = _move;
            
            // Check for jetpack
            if (input.jump && has_jetpack && jetpack_fuel > 0 && jump_released) {
                ysp = max(ysp + JETPACK_FORCE, JETPACK_MAX_SPEED);
                jetpack_fuel--;
            }
            
            // Transition to falling when velocity becomes positive
            if (ysp >= 0) {
                state_machine.change_state("FALL");
            }
        })
    );
    
// FALL state 
creature_props.state_machine.add_state("FALL", 
    method(creature_props, function() {
        // Use the falling_from_edge flag to set initial velocity
        if (falling_from_edge) {
            ysp = 0.1; // Just a small initial velocity
            falling_from_edge = false; // Reset the flag
        }
        // If not falling from edge, keep current velocity
    }),
    method(creature_props, function() {
        // Rest of the code remains the same
        ysp += GRAVITY;
        if (ysp > MAX_FALL_SPEED) ysp = MAX_FALL_SPEED;
        
        // Handle horizontal movement in air
        var _move = 0;
        if (input.right) _move = stats.get_move_speed();
        if (input.left) _move = -stats.get_move_speed();
        xsp = _move;
        
        // Check for jetpack
        if (input.jump && has_jetpack && jetpack_fuel > 0 && jump_released) {
            ysp = max(ysp + JETPACK_FORCE, JETPACK_MAX_SPEED);
            jetpack_fuel--;
        }
    })
);
    
    // KNOCKBACK state
    creature_props.state_machine.add_state("KNOCKBACK", 
        method(creature_props, function() {
            // Enter knockback state
            // (xsp and ysp should be set when transitioning to this state)
        }),
        method(creature_props, function() {
            // Apply gravity
            ysp += GRAVITY;
            
            // Apply drag to horizontal movement
            xsp *= 0.9;
            
            // Allow minimal control during knockback
            var control_speed = stats.get_move_speed() * 0.1;
            if (input.right) xsp = min(xsp + control_speed, stats.get_move_speed());
            if (input.left) xsp = max(xsp - control_speed, -stats.get_move_speed());
        })
    );
    
    // Start in IDLE state
    creature_props.state_machine.change_state("IDLE");
}