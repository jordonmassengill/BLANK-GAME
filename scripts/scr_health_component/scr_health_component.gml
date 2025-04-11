// scr_health_component.gml
// Enhanced health component with additional features

/// @function create_health_component(max_hp)
/// @description Creates a health component to manage health, damage, and healing
/// @param {real} max_hp - The maximum health for this entity
/// @returns {struct} A health component
function create_health_component(max_hp = 100) {
    return {
        entity: undefined,  // Will be set by init
        owner_instance: undefined, // Will be set by entity
        max_health: max_hp,
        current_health: max_hp,
        regen_rate: 0,  // Health regenerated per second
        damage_resistance: 0, // Damage reduction percentage (0-1)
        invulnerable: false,  // If true, takes no damage
        last_damage_time: 0,  // When damage was last taken
        last_damage_amount: 0, // How much damage was last taken
        last_damage_source: noone, // Who dealt the last damage
        is_dead: false,      // Whether entity is considered dead
        death_callback: undefined, // Optional function to call on death
        
        init: function(owner) {
            entity = owner;
            if (variable_instance_exists(entity, "owner_instance")) {
                owner_instance = entity.owner_instance;
            }
        },
        
        take_damage: function(amount, source = undefined, damage_type = undefined) {
            // Don't process if already dead or invulnerable
            if (is_dead || invulnerable) return 0;
            
            // Apply damage resistance
            var actual_damage = amount * (1 - damage_resistance);
            actual_damage = max(0, actual_damage);
            
            // Store damage info
            last_damage_time = current_time;
            last_damage_amount = actual_damage;
            last_damage_source = source;
            
            // Apply damage
            var old_health = current_health;
            current_health = max(0, current_health - actual_damage);
            
            // Show damage numbers if system exists
            if (variable_global_exists("damage_number_system") && owner_instance != undefined) {
                global.damage_number_system.add_number(owner_instance, actual_damage, false);
            }
            
            // Check for death
            if (current_health <= 0 && !is_dead) {
                is_dead = true;
                if (death_callback != undefined) {
                    death_callback();
                }
            }
            
            return actual_damage;
        },
        
        heal: function(amount, source = undefined) {
            // Don't heal if dead
            if (is_dead) return 0;
            
            var old_health = current_health;
            current_health = min(max_health, current_health + amount);
            var healed_amount = current_health - old_health;
            
            // Show healing numbers
            if (healed_amount > 0 && variable_global_exists("damage_number_system") && 
                owner_instance != undefined) {
                global.damage_number_system.add_number(owner_instance, healed_amount, true);
            }
            
            return healed_amount;
        },
        
        update: function(delta_time = 1/60) {
            // Skip if dead
            if (is_dead) return;
            
            // Apply regeneration
            if (regen_rate > 0) {
                heal(regen_rate * delta_time);
            }
        },
        
        set_max_health: function(new_max) {
            // Calculate health percent before change
            var health_percent = current_health / max_health;
            
            // Update max health
            max_health = new_max;
            
            // Scale current health proportionally (optional)
            current_health = max_health * health_percent;
            
            return self;
        },
        
        get_health_percent: function() {
            return current_health / max_health;
        },
        
        set_invulnerable: function(invuln_state) {
            invulnerable = invuln_state;
            return self;
        },
        
        set_death_callback: function(callback_func) {
            death_callback = callback_func;
            return self;
        },
        
        revive: function(health_percent = 1.0) {
            if (is_dead) {
                is_dead = false;
                current_health = max_health * health_percent;
                return true;
            }
            return false;
        },
        
        // Draw health bar (compatible with existing implementation)
        draw_health_bar: function() {
            // Make sure we have an owner_instance to position the health bar
            if (owner_instance == undefined) return;
            
            var health_width = 40;
            var health_height = 4;
            var health_y_offset = -32;
            
            var xx = owner_instance.x - health_width/2;
            var yy = owner_instance.y + health_y_offset;
            
            // Draw background
            draw_set_color(c_red);
            draw_rectangle(xx, yy, xx + health_width, yy + health_height, false);
            
            // Draw health
            draw_set_color(c_lime);
            draw_rectangle(xx, yy, xx + (health_width * get_health_percent()), yy + health_height, false);
            
            // Draw ticks for every 50 health
            draw_set_color(c_black);
            for (var i = 50; i < max_health; i += 50) {
                var tick_x = xx + (health_width * (i / max_health));
                draw_line(tick_x, yy, tick_x, yy + health_height);
            }
            
            // Draw border
            draw_rectangle(xx, yy, xx + health_width, yy + health_height, true);
            
            draw_set_color(c_white);
        }
    };
}