// This is the new, robust code
if (!stats_menu_active) exit;

// Actively find the player instance every frame, just like the shop does.
var player = instance_find(obj_player_creature_parent, 0);

// If no active player is found for any reason, do not continue.
if (player == noone) exit;

// Helper function to calculate level from current value
calculate_stat_level = function(current_value, base_value, per_level_value) {
    if (current_value < base_value) return 1; // Always minimum level 1
    return floor(((current_value - base_value) / per_level_value) + 1);
};

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

// Draw dark background with grid effect
draw_set_alpha(0.9);
draw_set_color(make_color_rgb(0, 10, 20));
draw_rectangle(0, 0, gui_width, gui_height, false);

// Draw subtle grid
draw_set_alpha(0.1);
draw_set_color(c_aqua);
for(var i = 0; i < gui_width; i += 20) {
    draw_line(i, 0, i, gui_height);
}
for(var i = 0; i < gui_height; i += 20) {
    draw_line(0, i, gui_width, i);
}

// Draw scanlines
draw_set_alpha(0.1);
for(var i = -10 + scanline_offset; i < gui_height; i += 10) {
    draw_set_color(c_black);
    draw_rectangle(0, i, gui_width, i + 5, false);
}

draw_set_alpha(1);

// Setup text properties
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);

var start_x = gui_width * 0.15;
var start_y = gui_height * 0.15;
var line_height = 50;

// Draw "STATS" title with neon effect
var title_x = start_x;
var title_y = start_y - 70;

// Outer glow for title
draw_set_color(make_color_rgb(0, 255, 255));
draw_set_alpha(0.3);
draw_text_transformed(title_x-2, title_y, "STATS", 3, 3, 0);
draw_text_transformed(title_x+2, title_y, "STATS", 3, 3, 0);
draw_text_transformed(title_x, title_y-2, "STATS", 3, 3, 0);
draw_text_transformed(title_x, title_y+2, "STATS", 3, 3, 0);

// Main title
draw_set_alpha(1);
draw_set_color(make_color_rgb(0, 255, 255));
draw_text_transformed(title_x, title_y, "STATS", 3, 3, 0);

// Get player stats
var stats = player.creature.stats;

// Draw stats list
for (var i = 0; i < array_length(stats_list); i++) {
    var stat = stats_list[i];
    var y_pos = start_y + (i * line_height);
    var current_value = 0;
    var current_level = 1;
    
    // Get current values
	var value_text = "Unknown"; // Declare at function scope before switch
    switch(stat.name) {
        case "Max Health":    
            current_value = player.entity.health.max_health;
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Life Steal":    
            current_value = stats.get_life_steal() * 100;
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Regeneration":    
            current_value = stats.get_health_regen();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Physical Damage":    
            current_value = stats.get_physical_damage();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Magical Damage":    
            current_value = stats.get_magical_damage();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Elemental Power":    
            current_value = stats.get_elemental_power();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Move Speed":    
            current_value = stats.get_move_speed();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Rate of Fire":    
            current_value = stats.get_rate_of_fire();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Projectile Speed":    
            current_value = stats.get_proj_speed();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Armor":    
            current_value = stats.get_armor();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Resistance":    
            current_value = stats.get_resistance();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
        case "Crit Level":
            current_value = stats.crit_level;
            current_level = current_value;
            if (current_level > 1) {
                var seconds_total = (stats.base_crit_cooldown - ((current_level - 1) * 60)) / 60;
                var multiplier = 1 + ((current_level - 1) * 0.25);
                value_text = string_format(multiplier, 1, 2) + "x/" + string(seconds_total) + "s";
            } else {
                value_text = "Inactive";
            }
            break;
        case "Area of Effect":
            current_value = stats.get_aoe_damage();
            current_level = calculate_stat_level(current_value, stat.base, stat.per_level);
            break;
    }

    // In upgrade mode, check for available upgrades
    if (upgrade_mode) {
        var required_type = stat.upgradeable_by;
        
        // --- THIS IS THE FIX ---
        // We now use our simple helper function instead of manually looping through the inventory.
        var available_points = player.entity.inventory.count_item(required_type);

        // If upgrades are available, use the appropriate color
        if (available_points > points_spent) {
            // Get color based on upgrade type
            var glow_color = ds_map_find_value(upgrade_colors, required_type);
            
            // Draw upgrade indicator with type-specific color
            draw_set_color(glow_color);
            draw_set_alpha(0.3);
            for(var g = 0; g < 360; g += 45) {
                draw_text_transformed(
                    start_x + lengthdir_x(2, g),    
                    y_pos + lengthdir_y(2, g),
                    stat.name + " (Level " + string(current_level) + ")",    
                    1.5, 1.5, 0
                );
            }
            
            // Draw upgrade text in matching color
            draw_set_alpha(1);
            draw_text_transformed(start_x - 80, y_pos, "UPGRADE", 1, 1, 0);
            
            if (i == selected_stat) {
                // Show upgrade instructions with matching color
                draw_text_transformed(
                    start_x + 900,    
                    y_pos,    
                    "Press SPACE to upgrade (" +    
                    string(available_points - points_spent) + " " +    
                    required_type + " points remaining)",    
                    1, 1, 0
                );
            }
        }
    }
	
    // Regular stat drawing (non-upgrade highlighting)
    if (i == selected_stat) {
        // We need to re-check available points here for the drawing logic, or pass it down.
        var points_for_highlight = 0;
        if (upgrade_mode) {
            points_for_highlight = player.entity.inventory.count_item(stat.upgradeable_by);
        }

        if (!upgrade_mode || points_for_highlight <= points_spent) {
            // Default cyan selection color when not upgradeable
            draw_set_color(make_color_rgb(0, 255, 255));
            draw_set_alpha(0.3);
            for(var g = 0; g < 360; g += 45) {
                draw_text_transformed(
                    start_x + lengthdir_x(2, g),    
                    y_pos + lengthdir_y(2, g),
                    stat.name + " (Level " + string(current_level) + ")",    
                    1.5, 1.5, 0
                );
            }
        }
        draw_set_alpha(1);
        draw_text_transformed(start_x - 40, y_pos, ">", 2, 2, 0);
        draw_set_color(make_color_rgb(0, 255, 255));
    } else {
        draw_set_color(c_white);
    }

    // Draw stat name and level
    draw_set_alpha(1);
    draw_text_transformed(start_x, y_pos, stat.name + " (Level " + string(current_level) + ")", 1.5, 1.5, 0);
    
    // Draw current value
    if (stat.name == "Crit Level") {
        if (current_level > 1) {
            var seconds_total = (stats.base_crit_cooldown - ((current_level - 1) * 60)) / 60; // Convert frames to seconds
            var multiplier = 1 + ((current_level - 1) * 0.25);
            value_text = string_format(multiplier, 1, 2) + "x/" + string(seconds_total) + "s";
        } else {
            value_text = "Inactive";
        }
    } else {
        value_text = stat.name == "Life Steal" ?    
            string_format(current_value, 1, 1) + "%" :
            string_format(current_value, 1, 2);
    }

    // Draw current value
    draw_set_color(c_white);
    draw_text_transformed(start_x + 400, y_pos, "[" + value_text + "]", 1.5, 1.5, 0);
    
    // Draw level bar
    var bar_x = start_x + 650;
    var bar_width = 300;
    var bar_height = 30;
    
    // Bar background
    draw_set_color(make_color_rgb(0, 40, 40));
    draw_rectangle(bar_x, y_pos, bar_x + bar_width, y_pos + bar_height, false);
    
    // Progress fill
    var fill_width = bar_width * (current_level/10);
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_rectangle(bar_x, y_pos, bar_x + fill_width, y_pos + bar_height, false);
    
    // Bar segments
    draw_set_color(make_color_rgb(0, 100, 100));
    for(var s = 1; s < 10; s++) {
        draw_line(bar_x + (bar_width * s/10), y_pos,    
                  bar_x + (bar_width * s/10), y_pos + bar_height);
    }
    
    // Bar border
    draw_set_color(make_color_rgb(0, 200, 200));
    draw_rectangle(bar_x, y_pos, bar_x + bar_width, y_pos + bar_height, true);
}

// Draw inventory section
var inventory_y = start_y + (array_length(stats_list) * line_height) + 50;

// Draw "INVENTORY" title with neon effect
var inventory_title_x = start_x;
var inventory_title_y = inventory_y;

// Outer glow for inventory title
draw_set_color(make_color_rgb(0, 255, 255));
draw_set_alpha(0.3);
draw_text_transformed(inventory_title_x-2, inventory_title_y, "INVENTORY", 2, 2, 0);
draw_text_transformed(inventory_title_x+2, inventory_title_y, "INVENTORY", 2, 2, 0);
draw_text_transformed(inventory_title_x, inventory_title_y-2, "INVENTORY", 2, 2, 0);
draw_text_transformed(inventory_title_x, inventory_title_y+2, "INVENTORY", 2, 2, 0);

// Main inventory title
draw_set_alpha(1);
draw_set_color(make_color_rgb(0, 255, 255));
draw_text_transformed(inventory_title_x, inventory_title_y, "INVENTORY", 2, 2, 0);

// Calculate inventory slot dimensions
var slot_size = 60;
var slot_padding = 10;
var slots_per_row = 8;

// +++ ADD THE NEW SUMMARY DRAWING LOGIC HERE +++
// +++ The NEW, Simplified Inventory Drawing Logic +++
if (variable_instance_exists(player, "entity") && player.entity.has_component("inventory")) {

    // Get the clean summary from our function (this part is correct and stays)
    var inventory_summary = player.entity.inventory.get_inventory_summary();
    
    // Define a starting Y position below the "INVENTORY" title
    var item_draw_y = inventory_y + 60;

    // Set text alignment for our list
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // --- Loop through the summary and draw a simple text line for each item ---
    for (var i = 0; i < array_length(inventory_summary); i++) {
        var item_info = inventory_summary[i];
        
        // Combine the name and count into one string
        var item_text = item_info.name + ": " + string(item_info.count);
        
        // Set the color based on the orb type
        draw_set_color(item_info.color);
        
        // Draw the text!
        draw_text_transformed(start_x, item_draw_y, item_text, 1.5, 1.5, 0);
        
        // Move the Y position down for the next item in the list
        item_draw_y += 40;
    }
}

// Reset drawing properties
draw_set_alpha(1);
draw_set_color(c_white);