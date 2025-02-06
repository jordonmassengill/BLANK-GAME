// scr_debug_stats
function draw_debug_stats(instance) {
    if (!variable_instance_exists(instance, "creature")) return;
    if (!variable_struct_exists(instance.creature, "stats")) return;
    
    var stats = instance.creature.stats;
	
    // Set smaller text size
    draw_set_font(-1); // Default font
    
    // Calculate sizes based on content
    var padding = 5;
    var line_height = 12;
    var box_width = 120;  // Reduced width
    var box_height = 100;  // Reduced height
    
    var camera = view_camera[0];
    var view_x = camera_get_view_x(camera);
    var view_y = camera_get_view_y(camera);
    var view_w = camera_get_view_width(camera);
    var view_h = camera_get_view_height(camera);
    
    // Position in top-left corner with small margin
    var xx = view_x + 10;
    var yy = view_y + 10;
    
    // Save old drawing settings
    var old_color = draw_get_color();
    var old_halign = draw_get_halign();
    var old_valign = draw_get_valign();
    
    // Set up drawing
    draw_set_color(c_black);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // Draw semi-transparent background
    draw_set_alpha(0.5);  // More transparent
    draw_rectangle(xx - padding, yy - padding, 
                  xx + box_width, yy + box_height, false);
    draw_set_alpha(1);
    
    // Draw stats
    draw_set_color(c_white);
    
    // Health (with current/max)
    draw_text(xx, yy, "Health: " + string(creature.current_health) + "/" + string(creature.max_health));
    yy += line_height;
    
    // Base stats
    draw_text(xx, yy, "Armor: " + string(stats.get_armor()) + 
             " (" + string(stats.armor) + "+" + string(stats.armor_bonus) + ")");
    yy += line_height;
	
	// NEW: Add resistance display
    draw_text(xx, yy, "Resistance: " + string(stats.get_resistance()) + "%" +
             " (" + string(stats.resistance) + "+" + string(stats.resistance_bonus) + ")");
    yy += line_height;
    
    draw_text(xx, yy, "Physical Dmg: " + string(stats.get_physical_damage()) + 
             " (" + string(stats.physical_damage) + "+" + string(stats.physical_damage_bonus) + ")");
    yy += line_height;
    
    draw_text(xx, yy, "Magical Dmg: " + string(stats.get_magical_damage()) + 
             " (" + string(stats.magical_damage) + "+" + string(stats.magical_damage_bonus) + ")");
    yy += line_height;
    
    draw_text(xx, yy, "Element Power: " + string(stats.get_elemental_power()) + 
             " (" + string(stats.elemental_power) + "+" + string(stats.elemental_power_bonus) + ")");
    yy += line_height;
    
    draw_text(xx, yy, "Move Speed: " + string(stats.get_move_speed()) + 
             " (" + string(stats.move_speed) + "+" + string(stats.speed_bonus) + ")");
    yy += line_height;
    
    draw_text(xx, yy, "Rate of Fire: " + string(stats.get_rate_of_fire()) + 
         " (" + string(stats.rate_of_fire) + "+" + string(stats.rof_bonus) + ")");
    yy += line_height;
    
    draw_text(xx, yy, "Proj Speed: " + string(stats.get_proj_speed()) + 
         " (" + string(stats.proj_speed) + "+" + string(stats.proj_speed_bonus) + ")");
    yy += line_height;

    draw_text(xx, yy, "Life Steal: " + string(stats.get_life_steal() * 100) + "%" +
         " (" + string(stats.life_steal * 100) + "+" + string(stats.life_steal_bonus * 100) + ")");
    yy += line_height;
    
    // Add divider line
    draw_line(xx, yy, xx + 130, yy);
    yy += line_height;
    
    // Additional info
    if (variable_instance_exists(creature, "has_fireball")) {
        draw_text(xx, yy, "Has Fireball: " + string(creature.has_fireball));
        yy += line_height;
    }
    
    if (variable_instance_exists(creature, "has_jetpack")) {
        draw_text(xx, yy, "Jetpack Fuel: " + string(creature.jetpack_fuel));
        yy += line_height;
    }
    
    // Restore old drawing settings
    draw_set_color(old_color);
    draw_set_halign(old_halign);
    draw_set_valign(old_valign);
}

// Create obj_debug_stats Create Event code
function create_debug_stats_controller() {
    instance_create_layer(0, 0, "instances", obj_debug_stats);
}