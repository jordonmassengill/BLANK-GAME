// obj_DeathScreen Draw GUI Event
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

if (started_fading) {
    // Create surface if it doesn't exist
    if (!surface_exists(surface)) {
        surface = surface_create(gui_width, gui_height);
    }
    
    // Copy screen to surface
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    draw_surface(application_surface, 0, 0);
    surface_reset_target();
    
    // Draw the surface with shader
    shader_set(shd_grayscale);
    draw_surface_ext(surface, 0, 0, 1, 1, 0, c_white, fade_alpha);
    shader_reset();
}

// Draw "YOU DIED" text with black outline
    if (fade_alpha >= 1 && current_delay >= (start_delay + text_delay)) {
        draw_set_font(-1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        var text_scale = 5;  // Increased from 3 to 5
        var text_x = gui_width/2;
        var text_y = gui_height/2;
        var outline_thickness = 4;  // How thick the black border should be
        
        // Draw black outline
        draw_set_alpha(text_alpha);
        draw_set_color(c_black);
        
        // Draw text 8 times offset for outline
        draw_text_transformed(text_x - outline_thickness, text_y, "YOU DIED", text_scale, text_scale, 0);
        draw_text_transformed(text_x + outline_thickness, text_y, "YOU DIED", text_scale, text_scale, 0);
        draw_text_transformed(text_x, text_y - outline_thickness, "YOU DIED", text_scale, text_scale, 0);
        draw_text_transformed(text_x, text_y + outline_thickness, "YOU DIED", text_scale, text_scale, 0);
        draw_text_transformed(text_x - outline_thickness, text_y - outline_thickness, "YOU DIED", text_scale, text_scale, 0);
        draw_text_transformed(text_x + outline_thickness, text_y - outline_thickness, "YOU DIED", text_scale, text_scale, 0);
        draw_text_transformed(text_x - outline_thickness, text_y + outline_thickness, "YOU DIED", text_scale, text_scale, 0);
        draw_text_transformed(text_x + outline_thickness, text_y + outline_thickness, "YOU DIED", text_scale, text_scale, 0);
        
        // Draw the red text on top
        draw_set_color(c_red);
        draw_text_transformed(text_x, text_y, "YOU DIED", text_scale, text_scale, 0);
    }

// Reset drawing properties
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);