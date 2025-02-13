// obj_Martin Step Event
event_inherited();

// Handle menu
if (shop_menu[? "active"]) {
    var player = instance_find(obj_player_creature_parent, 0);
    if (player != noone) {
        shop_menu_update(shop_menu, shop, player);
        
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
            if (player.creature.input.interact) {
                shop_menu[? "active"] = true;
                shop_menu[? "selected_item"] = 0;
                instance_deactivate_all(true);
                instance_activate_object(obj_Martin);
                instance_activate_object(obj_input_manager);
                instance_activate_object(player);
            }
        }
    }
}

// Handle walking and basic movement
if (!shop_menu[? "active"]) {
    if (moving_right) {
        x += walk_speed;
        image_xscale = 1;
        
        // Check for floor ahead
        var has_floor_ahead = position_meeting(x + edge_check_dist, y + sprite_height + 2, obj_floor);
        if (!has_floor_ahead || x >= patrol_point_right) {
            moving_right = false;
            image_xscale = -1;
        }
    } else {
        x -= walk_speed;
        image_xscale = -1;
        
        // Check for floor ahead
        var has_floor_ahead = position_meeting(x - edge_check_dist, y + sprite_height + 2, obj_floor);
        if (!has_floor_ahead || x <= patrol_point_left) {
            moving_right = true;
            image_xscale = 1;
        }
    }
}