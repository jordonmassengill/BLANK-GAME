// obj_pause_controller Draw GUI Event
if (game_paused) {
    // Draw semi-transparent black background
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    
    // Setup text properties
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(-1);
    
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var x_pos = gui_width / 2;
    var start_y = gui_height / 2 - ((array_length(menu_items) - 1) * 30);
    
    // Draw "PAUSED" text
    draw_set_color(c_white);
    draw_text_transformed(x_pos, start_y - 50, "PAUSED", 2, 2, 0);
    
    // Draw menu items
    for (var i = 0; i < array_length(menu_items); i++) {
        var y_pos = start_y + (i * 60);
        
        if (i == selected_item) {
            draw_set_color(c_yellow);
            draw_text_transformed(x_pos, y_pos, "> " + menu_items[i] + " <", 1.5, 1.5, 0);
        } else {
            draw_set_color(c_white);
            draw_text_transformed(x_pos, y_pos, menu_items[i], 1.2, 1.2, 0);
        }
    }
    
    // Reset draw properties
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}