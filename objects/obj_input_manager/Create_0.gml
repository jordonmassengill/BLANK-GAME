// obj_input_manager Create Event
menu_input_delay = 0;
menu_input_delay_max = 15;
was_stick_neutral = true;  // Track if stick was in neutral position

update_player_input = function(player_obj) {
    var input = player_obj.creature.input;
    
    if (input.using_controller) {
        // Regular inputs remain the same
        var axis_x = gamepad_axis_value(0, gp_axislh);
        input.left = (axis_x < -0.2);
        input.right = (axis_x > 0.2);
        
        input.jump = gamepad_button_check(0, gp_face1);
        input.fire = gamepad_button_check(0, gp_shoulderrb);
        
        input.aim_x = gamepad_axis_value(0, gp_axisrh);
        input.aim_y = gamepad_axis_value(0, gp_axisrv);
        
        input.pause_pressed = gamepad_button_check_pressed(0, gp_start);
        input.stats_menu_pressed = gamepad_button_check_pressed(0, gp_select);
        
        // Improved menu navigation
        var stick_y = gamepad_axis_value(0, gp_axislv);
        var stick_up = stick_y < -0.5;
        var stick_down = stick_y > 0.5;
        var stick_neutral = abs(stick_y) <= 0.5;
        
        // Reset delay if stick returns to neutral
        if (stick_neutral) {
            was_stick_neutral = true;
            menu_input_delay = 0;
        }
        
        // Handle menu navigation
        if ((stick_up || stick_down || gamepad_button_check(0, gp_padu) || gamepad_button_check(0, gp_padd))) {
            // If stick was neutral, allow immediate input
            if (was_stick_neutral || menu_input_delay <= 0) {
                input.menu_up = stick_up || gamepad_button_check(0, gp_padu);
                input.menu_down = stick_down || gamepad_button_check(0, gp_padd);
                menu_input_delay = menu_input_delay_max;
                was_stick_neutral = false;
            } else {
                input.menu_up = false;
                input.menu_down = false;
            }
        } else {
            input.menu_up = false;
            input.menu_down = false;
        }
        
        if (menu_input_delay > 0) menu_input_delay--;
        
        input.menu_select = gamepad_button_check_pressed(0, gp_face1);
        input.menu_back = gamepad_button_check_pressed(0, gp_face2);
        
        if (mouse_check_button_pressed(mb_left)) {
            input.using_controller = false;
        }
    } else {
        // Keyboard handling with similar improvements
        input.left = keyboard_check(ord("A"));
        input.right = keyboard_check(ord("D"));
        
        input.jump = keyboard_check(vk_space);
        input.fire = mouse_check_button(mb_left);
        
        input.target_x = mouse_x;
        input.target_y = mouse_y;
        
        input.pause_pressed = keyboard_check_pressed(vk_escape);
        input.stats_menu_pressed = keyboard_check_pressed(vk_tab);
        
        // Reset delay when keys are released
        if (!keyboard_check(vk_up) && !keyboard_check(vk_down)) {
            was_stick_neutral = true;
            menu_input_delay = 0;
        }
        
        // Handle keyboard menu navigation
        if (keyboard_check(vk_up) || keyboard_check(vk_down)) {
            if (was_stick_neutral || menu_input_delay <= 0) {
                input.menu_up = keyboard_check(vk_up);
                input.menu_down = keyboard_check(vk_down);
                menu_input_delay = menu_input_delay_max;
                was_stick_neutral = false;
            } else {
                input.menu_up = false;
                input.menu_down = false;
            }
        } else {
            input.menu_up = false;
            input.menu_down = false;
        }
        
        if (menu_input_delay > 0) menu_input_delay--;
        
        input.menu_select = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
        input.menu_back = keyboard_check_pressed(vk_escape);
        
        if (gamepad_button_check_pressed(0, gp_start)) {
            input.using_controller = true;
        }
    }
}