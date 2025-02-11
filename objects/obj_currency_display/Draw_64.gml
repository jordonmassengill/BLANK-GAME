// obj_currency_display Draw GUI Event
draw_set_font(-1);
draw_set_halign(fa_right);  // Change to right alignment
draw_set_valign(fa_bottom);

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var padding = 20;

// Get current currency
var player = instance_find(obj_player_creature_parent, 0);
if (player != noone) {
    var current_currency = player.creature.currency;
    
    // If currency changed, start flash effect
    if (current_currency > prev_currency) {
        flash_alpha = 1;
    }
    prev_currency = current_currency;
    
    // Smooth lerp with a check to ensure we reach the exact value
    if (abs(current_currency - display_currency) < 0.1) {
        display_currency = current_currency;  // Snap to final value when very close
    } else {
        display_currency = lerp(display_currency, current_currency, 0.1);
    }
}

// Calculate position from right side
var base_x = gui_width - padding;  // Changed to position from right
var base_y = gui_height - padding;

// Draw main currency display
draw_set_color(c_yellow);
draw_text_transformed(base_x, base_y, string(floor(display_currency)), 1.5, 1.5, 0);

// Draw flash effect when currency increases
if (flash_alpha > 0) {
    draw_set_alpha(flash_alpha);
    draw_set_color(c_white);
    draw_text_transformed(base_x, base_y, string(floor(display_currency)), 1.5, 1.5, 0);
    draw_set_alpha(1.0);
    flash_alpha = max(0, flash_alpha - (1/flash_duration));
}

// Reset draw properties
draw_set_color(c_white);
draw_set_halign(fa_left);  // Reset to left alignment
draw_set_valign(fa_top);