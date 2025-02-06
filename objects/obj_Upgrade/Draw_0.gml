// obj_upgrade_platform Draw Event

// Draw the normal sprite
draw_self();

var player = instance_nearest(x, y, obj_player_creature_parent);
if (player != noone) {
    // Calculate centers and distance
    var platform_center = x;  // Use x position directly since sprite is centered
    var player_center = player.x + (player.sprite_width / 2);
    var center_threshold = 10;
    var is_centered = abs(platform_center - player_center) <= center_threshold;
    var dist = point_distance(x, y, 
                            player.x + player.sprite_width/2, 
                            player.y + player.sprite_height/2);
    
    // Update pulse
    if (dist < detection_range) {
        pulse += pulse_speed * pulse_direction;
        if (pulse >= pulse_max || pulse <= pulse_min) {
            pulse_direction *= -1;
        }
        
        // Calculate glow intensity based on distance
        var intensity = 1 - (dist / detection_range);
        glow_alpha = intensity * 0.6;  // Max alpha of 0.6
        
        // Change color if centered
        if (is_centered) {
            glow_color = make_color_rgb(0, 255, 100);  // Green when centered
            glow_alpha *= 1.5;  // Brighter when centered
        } else {
            glow_color = make_color_rgb(0, 255, 255);  // Cyan when near
        }
        
        // Get actual sprite dimensions
        var actual_width = sprite_get_width(sprite_index);
        var actual_height = sprite_get_height(sprite_index);
        var half_width = actual_width / 2;
        
        // Draw outer glow (centered on platform)
        draw_set_alpha(glow_alpha);
        draw_set_color(glow_color);
        draw_rectangle(x - half_width - 2, y - 2, 
                      x + half_width + 2, y + actual_height + 2, false);
        
        // Draw inner platform glow
        draw_set_alpha(glow_alpha * 0.5);
        draw_rectangle_color(x - half_width, y, 
                           x + half_width, y + actual_height,
                           glow_color, glow_color, glow_color, glow_color, false);
        
        // Draw scanlines
        draw_set_alpha(glow_alpha * 0.3);
        for(var i = y; i < y + actual_height; i += 2) {
            draw_line_color(x - half_width, i, x + half_width, i, glow_color, glow_color);
        }
    }
}

// Reset draw properties
draw_set_alpha(1);
draw_set_color(c_white);