// scr_damage_numbers
function create_floating_number() {
    return {
        value: 0,
        x: 0,
        y: 0,
        is_healing: false,
        base_y: 0,          // Store original y position
        y_offset: 0,        // For floating effect
        alpha: 1,           // For fade effect
        pause_timer: 90,    // 1.5 seconds at 60fps
        is_paused: true,    // Start paused
        
        initialize: function(val, xx, yy, is_heal) {
            value = val;
            x = xx;
            y = yy;
            base_y = yy;    // Store original y
            y_offset = 0;
            alpha = 1;
            is_healing = is_heal;
            pause_timer = 90;
            is_paused = true;
        },
        
        reset_animation: function() {
            y_offset = 0;
            alpha = 1;
            pause_timer = 90;
            is_paused = true;
        }
    };
}

function create_damage_number_manager() {
    return {
        damage_numbers: ds_map_create(),
        healing_numbers: ds_map_create(),
        
        cleanup: function() {
            ds_map_destroy(damage_numbers);
            ds_map_destroy(healing_numbers);
        },
        
        update: function() {
            self.update_map(damage_numbers);
            self.update_map(healing_numbers);
        },
        
        update_map: function(map) {
            var key = ds_map_find_first(map);
            while (!is_undefined(key)) {
                var number = map[? key];
                var next_key = ds_map_find_next(map, key);
                
                // Handle pause state
                if (number.is_paused) {
                    number.pause_timer--;
                    if (number.pause_timer <= 0) {
                        number.is_paused = false;
                    }
                } else {
                    // After pause, handle floating and fading
                    number.y_offset -= 0.5;  // Float up
                    number.alpha -= 0.02;    // Fade out
                    
                    // Remove if fully faded
                    if (number.alpha <= 0) {
                        ds_map_delete(map, key);
                    }
                }
                
                key = next_key;
            }
        },
        
        add_number: function(target_id, amount, is_healing) {
    var map = is_healing ? healing_numbers : damage_numbers;
    
    if (ds_map_exists(map, target_id)) {
        var existing_number = map[? target_id];
        existing_number.value += amount;
        
        // Update position to match target's new position
        if (instance_exists(target_id)) {
            var target = target_id;
            existing_number.x = target.x + (is_healing ? 20 : -20);
            existing_number.y = target.y - target.sprite_height;
            existing_number.base_y = existing_number.y;  // Update base_y too
        }
        
        existing_number.reset_animation();
    } else {
        var number = create_floating_number();
        if (instance_exists(target_id)) {
            var target = target_id;
            number.initialize(amount, 
                           target.x + (is_healing ? 20 : -20),
                           target.y - target.sprite_height,
                           is_healing);
            ds_map_add(map, target_id, number);
        }
    }
},
        
        draw: function() {
            draw_set_halign(fa_center);
            
            // Draw damage numbers
            var key = ds_map_find_first(damage_numbers);
            while (!is_undefined(key)) {
                var number = damage_numbers[? key];
                var text = string(ceil(number.value));
                var scale = 1.2;
                
                draw_set_alpha(number.alpha);
                
                // Draw black outline
                draw_set_color(c_black);
                draw_text_transformed(number.x - 1, number.base_y + number.y_offset, text, scale, scale, 0);
                draw_text_transformed(number.x + 1, number.base_y + number.y_offset, text, scale, scale, 0);
                draw_text_transformed(number.x, number.base_y + number.y_offset - 1, text, scale, scale, 0);
                draw_text_transformed(number.x, number.base_y + number.y_offset + 1, text, scale, scale, 0);
                
                // Draw red number
                draw_set_color(c_red);
                draw_text_transformed(number.x, number.base_y + number.y_offset, text, scale, scale, 0);
                key = ds_map_find_next(damage_numbers, key);
            }
            
            // Draw healing numbers
            key = ds_map_find_first(healing_numbers);
            while (!is_undefined(key)) {
                var number = healing_numbers[? key];
                var text = string(ceil(number.value));
                var scale = 1.2;
                
                draw_set_alpha(number.alpha);
                
                // Draw black outline
                draw_set_color(c_black);
                draw_text_transformed(number.x - 1, number.base_y + number.y_offset, text, scale, scale, 0);
                draw_text_transformed(number.x + 1, number.base_y + number.y_offset, text, scale, scale, 0);
                draw_text_transformed(number.x, number.base_y + number.y_offset - 1, text, scale, scale, 0);
                draw_text_transformed(number.x, number.base_y + number.y_offset + 1, text, scale, scale, 0);
                
                // Draw green number
                draw_set_color(c_lime);
                draw_text_transformed(number.x, number.base_y + number.y_offset, text, scale, scale, 0);
                key = ds_map_find_next(healing_numbers, key);
            }
            
            draw_set_alpha(1);
            draw_set_color(c_white);
            draw_set_halign(fa_left);
        }
    };
}

function init_damage_numbers() {
    global.damage_number_system = create_damage_number_manager();
}