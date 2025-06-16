// scr_shop.gml

// Function to create a shop inventory
function create_shop_inventory() {
    var shop = ds_map_create();
    shop[? "items"] = ds_list_create();
    return shop;
}

// Function to add an item to the shop inventory
function shop_add_item(shop, item_name, price, item_object, description) {
    var item = ds_map_create();
    item[? "name"] = item_name;
    item[? "price"] = price;
    item[? "object"] = item_object;
    item[? "description"] = description;
    ds_list_add(shop[? "items"], item);
}

// Function to create a shop menu
function create_shop_menu() {
    var menu = ds_map_create();
    menu[? "active"] = false; // Whether the menu is currently open
    menu[? "selected_item"] = 0; // Index of the currently selected item
    return menu;
}

function shop_menu_update(menu, shop, player) {
    if (menu[? "active"]) {
        // Handle menu navigation
        if (player.creature.input.menu_up && menu[? "selected_item"] > 0) {
            menu[? "selected_item"]--;
        }
        
        if (player.creature.input.menu_down && menu[? "selected_item"] < ds_list_size(shop[? "items"]) - 1) {
            menu[? "selected_item"]++;
        }

        // Handle item purchase
        if (player.creature.input.menu_select) {
            var selected_item = ds_list_find_value(shop[? "items"], menu[? "selected_item"]);
            if (player.creature.currency >= selected_item[? "price"]) {
                // Create the item
                if (selected_item[? "object"] != noone && selected_item[? "object"] != undefined) {
                    instance_create_layer(player.x, player.y, "Instances", selected_item[? "object"]);
                    player.creature.currency -= selected_item[? "price"];
                }
            }
        }

        // Handle closing shop
        if (player.creature.input.menu_back) {
            menu[? "active"] = false;
            instance_activate_all();
        }
    }
}

function shop_menu_draw(menu, shop, x, y) {
    if (!menu[? "active"]) return;
    
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    
    // Draw dark background overlay
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, gui_height, false);
    draw_set_alpha(1);
    
    // Draw main shop window
    var window_width = gui_width * 0.8;
    var window_height = gui_height * 0.8;
    var window_x = (gui_width - window_width) / 2;
    var window_y = (gui_height - window_height) / 2;
    
    // Draw window background
    draw_set_color(make_colour_rgb(20, 20, 30));
    draw_rectangle(window_x, window_y, window_x + window_width, window_y + window_height, false);
    
    // Draw cyan border
    draw_set_color(c_aqua);
    draw_rectangle(window_x, window_y, window_x + window_width, window_y + window_height, true);
    
    // Draw title
    draw_set_font(-1);
    draw_set_color(c_aqua);
    draw_set_halign(fa_center);
    draw_text_transformed(window_x + window_width/2, window_y + 20, "MARTIN'S SHOP", 2, 2, 0);
    
    // Draw player's currency
    var player = instance_find(obj_player_creature_parent, 0);
    if (player != noone) {
        draw_set_halign(fa_right);
        draw_set_color(c_yellow);
        draw_text_transformed(window_x + window_width - 20, window_y + 20, 
            "Currency: " + string(player.creature.currency), 1.5, 1.5, 0);
    }
    
    // Draw items
    var start_y = window_y + 80;
    var item_height = 60;
    var items = shop[? "items"];
    var menu_x = window_x + 40;  // Menu start position
    var menu_width = window_width * 0.45;  // Reduced from 0.6 to 0.45
    
    for (var i = 0; i < ds_list_size(items); i++) {
        var item = items[| i];
        var item_y = start_y + (i * item_height);
        
        // Draw selection highlight with smaller width
        if (i == menu[? "selected_item"]) {
            draw_set_color(c_aqua);
            draw_set_alpha(0.3);
            draw_rectangle(menu_x - 10, item_y,  
                menu_x + menu_width - 120, // Reduced end point
                item_y + item_height - 5, false);
            draw_set_alpha(1);
        }
        
        // Draw price first
        draw_set_halign(fa_left);
        draw_set_color(c_yellow);
        draw_text_transformed(menu_x, item_y + 5, 
            string(item[? "price"]) + " gold", 1.2, 1.2, 0);
        
        // Draw item info with offset for price
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_text_transformed(menu_x + 120, item_y + 5, item[? "name"], 1.2, 1.2, 0);
        
        draw_set_color(c_gray);
        draw_text(menu_x + 120, item_y + 30, item[? "description"]);
    }
    
    // Draw inventory section
    var inventory_x = window_x + window_width * 0.7;
    var inventory_y = window_y + 80;
    
    draw_set_color(c_aqua);
    draw_text_transformed(inventory_x, inventory_y, "INVENTORY", 1.5, 1.5, 0);
    
    if (player != noone) {
    var inventory_items = player.entity.inventory.items;
    var inv_y = inventory_y + 40;
    
    for (var i = 0; i < array_length(inventory_items); i++) {
        var item = inventory_items[i];
        if (item != undefined && is_struct(item)) {  // Add this check
            draw_set_color(c_white);
            draw_text(inventory_x, inv_y, item.name);
            if (variable_struct_exists(item, "count")) {
                draw_text(inventory_x + 150, inv_y, "x" + string(item.count));
            }
            inv_y += 30;
        }
    }
}
    
    // Draw controls
draw_set_color(c_gray);
draw_set_halign(fa_left);
var controls_text = "";
if (player.creature.input.using_controller) {
    controls_text = "↑/↓: Navigate   A: Buy   B: Close   Y: Open Shop";
} else {
    controls_text = "↑/↓: Navigate   SPACE: Buy   ESC: Close";
}
draw_text(window_x + 20, window_y + window_height - 30, controls_text);
    
    // Reset draw properties
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_set_alpha(1);
}