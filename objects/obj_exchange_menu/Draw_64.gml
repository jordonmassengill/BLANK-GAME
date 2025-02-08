// obj_exchange_menu Draw GUI Event
if (!menu_active) exit;

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var line_height = 40;

// Draw dark background
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// Set up columns
var left_col_x = gui_width * 0.2;
var right_col_x = gui_width * 0.6;
var start_y = gui_height * 0.2;

// Draw title
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_transformed(left_col_x, start_y - 50, "Exchange Orbs", 2, 2, 0);

// Draw column headers
draw_set_color(c_gray);
draw_text(left_col_x, start_y - 20, "Your Inventory");
draw_text(right_col_x, start_y - 20, "Available Orbs");

var player = instance_find(obj_player_creature_parent, 0);
if (player) {
    // Draw inventory column
var items = player.creature.inventory.items;
var display_index = 0;
ds_map_clear(display_to_inventory_slot);  // Clear previous mappings

for (var i = 0; i < array_length(items); i++) {
    var valid_types = ["life", "power", "speed", "defense", "manifest", "blank"];
    
    if (items[i] != undefined && array_contains(valid_types, items[i].type)) {
        // If this item is stacked, we need to create display entries for each count
        var count = variable_struct_exists(items[i], "count") ? items[i].count : 1;
        
        for(var j = 0; j < count; j++) {
            var y_pos = start_y + (display_index * line_height);
            
            // Map this display index to the inventory slot
            ds_map_add(display_to_inventory_slot, display_index, i);
            
            // Draw selection highlight if slot is selected
            if (array_get_index(selected_inventory_slots, display_index) != -1) {
                draw_set_color(c_yellow);
                draw_set_alpha(0.3);
                draw_rectangle(left_col_x - 10, y_pos, left_col_x + 200, y_pos + line_height - 5, false);
                draw_set_alpha(1);
            }
            
            // Draw cursor if this is the selected item in inventory
            if (cursor_position == "inventory" && display_index == selected_item) {
                draw_set_color(c_white);
                draw_text(left_col_x - 20, y_pos, ">");
            }
            
            // Draw orb
            draw_set_color(items[i].color);
            draw_circle(left_col_x + 10, y_pos + line_height/2, 8, false);
            draw_set_color(c_white);
            draw_text(left_col_x + 30, y_pos, items[i].name);
            
            display_index++;
        }
    }
}
    
    // Draw available orbs column
    for (var i = 0; i < array_length(orb_types); i++) {
        var y_pos = start_y + (i * line_height);
        
        // Draw cursor if this is the selected item in options
        if (cursor_position == "options" && i == selected_item) {
            draw_set_color(c_white);
            draw_text(right_col_x - 20, y_pos, ">");
        }
        
        // Draw orb
        draw_set_color(orb_types[i].color);
        draw_circle(right_col_x + 10, y_pos + line_height/2, 8, false);
        draw_set_color(c_white);
        draw_text(right_col_x + 30, y_pos, orb_types[i].name);
    }
}

// Draw instructions
draw_set_color(c_gray);
draw_text(left_col_x, gui_height - 80, "← → to switch columns");
draw_text(left_col_x, gui_height - 60, "↑ ↓ to move cursor");
draw_text(left_col_x, gui_height - 40, "SPACE to select/convert");
draw_text(left_col_x, gui_height - 20, "ESC to clear selection/exit");

// Reset drawing properties
draw_set_alpha(1);
draw_set_color(c_white);