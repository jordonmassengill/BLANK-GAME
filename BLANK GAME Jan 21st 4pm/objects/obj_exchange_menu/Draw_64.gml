// obj_exchange_menu Draw GUI Event
if (!menu_active) exit;

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var center_x = gui_width / 2;
var center_y = gui_height / 2;

// Background
draw_set_color(color_background);
draw_rectangle(0, 0, gui_width, gui_height, false);

// Grid pattern
draw_set_color(make_colour_rgb(0, 50, 100));
gpu_set_blendmode(bm_add);
var grid_step = 64;

for (var yy = 0; yy < gui_height + grid_step; yy += grid_step) {
    for (var xx = 0; xx < gui_width + grid_step; xx += grid_step) {
        var char_index = (xx + yy + timer) mod string_length(grid_chars);
        var display_char = string_char_at(grid_chars, char_index + 1);
        draw_text_transformed(xx + timer % 64, yy, display_char, 1.2, 1.2, 0);
    }
}
gpu_set_blendmode(bm_normal);

// Animated scanlines
draw_set_alpha(0.2);
draw_set_color(c_white);
for (var scanline = scanline_offset; scanline < gui_height; scanline += 8) {
    draw_line(0, scanline, gui_width, scanline);
}
draw_set_alpha(1);

// Main container
var container_size = 0.8;
var container_w = gui_width * container_size;
var container_h = gui_height * 0.7;
var container_x = center_x - container_w / 2;
var container_y = center_y - container_h / 2;

// Glowing border
gpu_set_blendmode(bm_add);
draw_set_alpha(glow_alpha);
draw_set_color(color_primary);
draw_rectangle(container_x - 5, container_y - 5, 
               container_x + container_w + 5, container_y + container_h + 5, true);
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);

// Main panel
draw_set_alpha(0.8);
draw_set_color(make_colour_rgb(0, 30, 60));
draw_rectangle(container_x, container_y, 
               container_x + container_w, container_y + container_h, false);
draw_set_alpha(1);

// Title text
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var title_y = container_y + 40;
draw_set_color(color_primary);
draw_text_transformed(center_x, title_y, "ORB EXCHANGE SYSTEM", 2.5, 2.5, 0);

// Columns
var col_space = 100;
var col1_x = container_x + col_space;
var col2_x = container_x + container_w - col_space - 300;
var content_y = container_y + 120;

// Clear previous mappings
ds_map_clear(display_to_inventory_slot);

var player = instance_find(obj_player_creature_parent, 0);
if (!player) exit;

// Draw inventory items with stacking support
var items = player.creature.inventory.items;
var display_index = 0;

for (var i = 0; i < array_length(items); i++) {
    if (items[i] != undefined && array_contains(valid_types, items[i].type)) {
        var count = variable_struct_exists(items[i], "count") ? items[i].count : 1;
        
        for (var j = 0; j < count; j++) {
            var yy = content_y + (display_index * 60);
            
            // Map display index to inventory slot
            ds_map_add(display_to_inventory_slot, display_index, i);
            
            // Selection highlight
            if (array_contains(selected_inventory_slots, display_index)) {
                draw_set_color(color_highlight);
                draw_set_alpha(0.3);
                draw_rectangle(col1_x - 10, yy - 15, col1_x + 250, yy + 45, false);
                draw_set_alpha(1);
            }

            // Item background with cyberpunk effect
            draw_set_color(make_colour_rgb(0, 50, 100));
            draw_rectangle(col1_x, yy, col1_x + 230, yy + 30, false);

            // Draw animated orb
            draw_set_color(items[i].color);
            draw_circle(col1_x + 30, yy + 15, 12 + sin(timer / 10 + display_index) * 2, false);
            
            // Draw item name
            draw_set_color(c_white);
            draw_text(col1_x + 50, yy + 2, items[i].name);
            
            display_index++;
        }
    }
}

// Available orb types
for (var i = 0; i < array_length(orb_types); i++) {
    var yy = content_y + (i * 60);

    // Selection highlight with pulse effect
    if (cursor_position == "options" && i == selected_item) {
        draw_set_alpha(active_pulse * 0.3);
        draw_set_color(color_highlight);
        draw_rectangle(col2_x - 10, yy - 15, col2_x + 250, yy + 45, false);
        draw_set_alpha(1);
    }

    // Orb display with animation
    draw_set_color(orb_types[i].color);
    draw_circle(col2_x + 30, yy + 15, 12 + sin(timer / 10 + i) * 2, false);
    draw_set_color(c_white);
    draw_text(col2_x + 50, yy + 2, orb_types[i].name);
}

// Cursor indicators with glow effect
draw_set_color(color_highlight);
if (cursor_position == "inventory") {
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(col1_x - 30, content_y + (selected_item * 60) + 15);
    draw_vertex(col1_x - 20, content_y + (selected_item * 60) + 20);
    draw_vertex(col1_x - 30, content_y + (selected_item * 60) + 25);
    draw_primitive_end();
} else {
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(col2_x + 280, content_y + (selected_item * 60) + 15);
    draw_vertex(col2_x + 270, content_y + (selected_item * 60) + 20);
    draw_vertex(col2_x + 280, content_y + (selected_item * 60) + 25);
    draw_primitive_end();
}

// Instructions with cyberpunk style
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(color_primary);
var instructions_y = container_y + container_h - 20;
draw_text(col1_x, instructions_y, "←/→: Switch Panels");
draw_text(col1_x, instructions_y - 20, "↑/↓: Navigate");
draw_text(col2_x, instructions_y, "SPACE: Confirm");
draw_text(col2_x, instructions_y - 20, "ESC: Cancel");

// Reset drawing properties
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
gpu_set_blendmode(bm_normal);