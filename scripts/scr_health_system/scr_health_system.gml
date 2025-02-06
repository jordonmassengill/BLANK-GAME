// scr_health_system consolidated
function create_health_system() {
    return {
        damage_creature: function(target, amount) {
            if (!variable_instance_exists(target, "creature")) return 0;
            
            target.creature.current_health -= amount;
            
            // Call hit function if it exists
            if (variable_instance_exists(target, "hit")) {
                target.hit();
            }
            
            if (variable_global_exists("damage_number_system")) {
                global.damage_number_system.add_number(target.id, amount, false);
            }
            
            return amount;
        },

        modify_health: function(target, amount) {
            if (!variable_instance_exists(target, "creature")) return 0;
            
            var old_health = target.creature.current_health;
            target.creature.current_health = clamp(old_health + amount, 0, target.creature.max_health);
            var health_change = target.creature.current_health - old_health;
            
            if (health_change != 0 && variable_global_exists("damage_number_system")) {
                global.damage_number_system.add_number(target.id, abs(health_change), health_change > 0);
            }
            
            return health_change;
        },
        
        // Rest of the health system stays exactly the same
        apply_life_steal: function(attacker, damage_dealt) {
            if (!variable_instance_exists(attacker, "creature")) return;
            
            var life_steal_amount = attacker.creature.stats.get_life_steal();
            if (life_steal_amount > 0) {
                var heal_amount = damage_dealt * life_steal_amount;
                self.modify_health(attacker, heal_amount);
            }
        },
        
        draw_health_bar: function(instance_id) {
            if (!variable_instance_exists(instance_id, "creature")) return;
            
            var health_width = 40;
            var health_height = 4;
            var health_y_offset = -32;
            
            var xx = instance_id.x - health_width/2;
            var yy = instance_id.y + health_y_offset;
            
            var creature = instance_id.creature;
            var health_percent = creature.current_health / creature.max_health;
            
            // Draw background
            draw_set_color(c_red);
            draw_rectangle(xx, yy, xx + health_width, yy + health_height, false);
            
            // Draw health
            draw_set_color(c_lime);
            draw_rectangle(xx, yy, xx + (health_width * health_percent), yy + health_height, false);
            
            // Draw ticks
            draw_set_color(c_black);
            for(var i = 50; i < creature.max_health; i += 50) {
                var tick_x = xx + (health_width * (i/creature.max_health));
                draw_line(tick_x, yy, tick_x, yy + health_height);
            }
            
            // Draw border
            draw_rectangle(xx, yy, xx + health_width, yy + health_height, true);
            
            draw_set_color(c_white);
        }
    };
}