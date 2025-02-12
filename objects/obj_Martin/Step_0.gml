// obj_Martin Step Event
event_inherited();

// Handle menu
if (shop_menu[? "active"]) {
    var player = instance_find(obj_player_creature_parent, 0);
    if (player != noone) {
        shop_menu_update(shop_menu, shop, player);
        
        // Handle closing shop with back button
        if (player.creature.input.menu_back) {
            shop_menu[? "active"] = false;
            instance_activate_all();
        }
    }
}

// Check for player interaction
if (!shop_menu[? "active"]) {
    var player = instance_place(x, y - 1, obj_player_creature_parent);
    if (player != noone) {
        var platform_center = x;
        var player_center = player.x;
        var center_threshold = 32;

        if (abs(platform_center - player_center) <= center_threshold) {
            // Check for either keyboard space or controller Y button
            if (player.creature.input.interact) {
                shop_menu[? "active"] = true;
                shop_menu[? "selected_item"] = 0;
                instance_deactivate_all(true);
                instance_activate_object(obj_Martin);
                instance_activate_object(obj_input_manager);
                instance_activate_object(player);
                show_debug_message("Shop menu activated!"); // Debug message
            }
        }
    }
}

// Handle walking and basic movement
if (!shop_menu[? "active"]) {
    x += lengthdir_x(walk_speed, direction);

    // Check for collisions or edges
    if (place_meeting(x + lengthdir_x(walk_speed, direction), y, obj_floor)) {
        direction = direction == 0 ? 180 : 0;  // Turn around
        image_xscale = (direction == 0) ? 1 : -1;  // Flip sprite
    }

    // Change direction randomly sometimes
    if (random(1) < 0.005) {  // 0.5% chance per step to turn around
        direction = direction == 0 ? 180 : 0;
        image_xscale = (direction == 0) ? 1 : -1;
    }
}