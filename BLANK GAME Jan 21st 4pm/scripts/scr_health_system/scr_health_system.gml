// scr_health_system.gml - Component-based health system
function create_health_system() {
    return {
        damage_creature: function(target, amount) {
            // Safety check for target
            if (target == noone || !instance_exists(target)) return 0;
            
            // Round the damage to 2 decimal places
            amount = round(amount * 100) / 100;
            
            var actual_damage = 0;
            
            // Use component system
            if (variable_instance_exists(target, "entity") && 
                variable_struct_exists(target.entity, "health")) {
                
                // Apply damage via component
                actual_damage = target.entity.health.take_damage(amount);
            }
            else {
                // Target doesn't have health component
                return 0;
            }
            
            // Call hit function if it exists
            if (variable_instance_exists(target, "hit")) {
                target.hit(amount);
            }
            
            // Show damage numbers
            if (variable_global_exists("damage_number_system")) {
                global.damage_number_system.add_number(target, amount, false);
            }
            
            return actual_damage;
        },
        
        modify_health: function(target, amount) {
            // Safety check for target
            if (target == noone || !instance_exists(target)) return 0;
            
            var health_change = 0;
            
            // Use component system
            if (variable_instance_exists(target, "entity") && 
                variable_struct_exists(target.entity, "health")) {
                
                if (amount > 0) {
                    // Apply healing via component
                    health_change = target.entity.health.heal(amount);
                } else {
                    // Apply damage via component
                    health_change = -target.entity.health.take_damage(-amount);
                }
            }
            else {
                // Target doesn't have health component
                return 0;
            }
            
            // Show health change numbers
            if (health_change != 0 && variable_global_exists("damage_number_system")) {
                global.damage_number_system.add_number(target, abs(health_change), health_change > 0);
            }
            
            return health_change;
        },
        
        // Apply life steal
        apply_life_steal: function(attacker, damage_dealt) {
            if (attacker == noone || !instance_exists(attacker)) return;
            
            var life_steal_amount = 0;
            
            // Get life steal amount from stats
            if (variable_instance_exists(attacker, "creature") && 
                variable_struct_exists(attacker.creature, "stats") &&
                variable_struct_exists(attacker.creature.stats, "get_life_steal")) {
                life_steal_amount = attacker.creature.stats.get_life_steal();
            }
            
            // Apply healing if life steal is available
            if (life_steal_amount > 0 && 
                variable_instance_exists(attacker, "entity") && 
                variable_struct_exists(attacker.entity, "health")) {
                
                var heal_amount = damage_dealt * life_steal_amount;
                attacker.entity.health.heal(heal_amount);
                
                // Show healing numbers
                if (variable_global_exists("damage_number_system")) {
                    global.damage_number_system.add_number(attacker, heal_amount, true);
                }
            }
        },
        
        // Draw health bar
        draw_health_bar: function(instance_id) {
            // Safety check
            if (instance_id == noone || !instance_exists(instance_id)) return;
            
            // Use component draw function if available
            if (variable_instance_exists(instance_id, "entity") && 
                variable_struct_exists(instance_id.entity, "health") &&
                variable_struct_exists(instance_id.entity.health, "draw_health_bar")) {
                instance_id.entity.health.draw_health_bar();
            }
        }
    };
}