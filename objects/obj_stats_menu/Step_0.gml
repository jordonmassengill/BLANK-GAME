// obj_stats_menu Step Event
scanline_offset += 0.5;
if (scanline_offset >= 10) scanline_offset = 0;

var player = instance_find(obj_player_creature_parent, 0);
if (!player) exit;

// Handle menu toggling with TAB
if (player.creature.input.stats_menu_pressed) {
    stats_menu_active = !stats_menu_active;  // Toggle menu
    if (stats_menu_active) {
        instance_deactivate_all(true);
        instance_activate_object(obj_stats_menu);
        instance_activate_object(obj_input_manager);
        instance_activate_object(obj_player_creature_parent);
    } else {
        instance_activate_all();
    }
}

// Only handle the rest if menu is active
if (stats_menu_active) {
    // Menu navigation
    if (player.creature.input.menu_up) {
        selected_stat--;
        if (selected_stat < 0) selected_stat = array_length(stats_list) - 1;
    }
    
    if (player.creature.input.menu_down) {
        selected_stat++;
        if (selected_stat >= array_length(stats_list)) selected_stat = 0;
    }

    // Handle upgrades in upgrade mode
    if (upgrade_mode) {
        var available_points = 0;
        var creature = player.creature;
        var upgrade_type = stats_list[selected_stat].upgradeable_by;

        // Calculate available points for the current upgrade type
        if (is_struct(creature) && variable_struct_exists(creature, "inventory")) {
            var items = creature.inventory.items;
            for (var i = 0; i < array_length(items); i++) {
                if (items[i] != undefined && items[i].type == upgrade_type) {
                    available_points++;
                }
            }
        }

        var selected = stats_list[selected_stat];
        if (player.creature.input.menu_select && 
            available_points > points_spent) {
            
            switch (selected.name) {
                // Life upgrades
                case "Max Health":
                    player.creature.max_health += 50;
                    player.creature.current_health += 50;
                    points_spent++;
                    break;
                    
                case "Life Steal":
                    player.creature.stats.life_steal_bonus += 0.05;
                    points_spent++;
                    break;
                    
                case "Regeneration":
                    player.creature.stats.health_regen += 1;
                    points_spent++;
                    break;

                // Speed upgrades
                case "Move Speed":
                    player.creature.stats.move_speed += 0.25;
                    points_spent++;
                    break;

                case "Rate of Fire":
                    player.creature.stats.rate_of_fire += 0.25;
                    points_spent++;
                    break;

                case "Projectile Speed":
                    player.creature.stats.proj_speed += 0.25;
                    points_spent++;
                    break;
                    
                // Power upgrades
                case "Physical Damage":
                    player.creature.stats.physical_damage += 1;
                    points_spent++;
                    break;

                case "Magical Damage":
                    player.creature.stats.magical_damage += 1;
                    points_spent++;
                    break;

                // Manifest upgrades
                case "Elemental Power":
                    player.creature.stats.elemental_power += 1;
                    points_spent++;
                    break;

                // Defense upgrades
                case "Armor":
                    player.creature.stats.armor += 1;
                    points_spent++;
                    break;

                case "Resistance":
                    player.creature.stats.resistance += 1;
                    points_spent++;
                    break;

                // Finesse upgrade
                case "Crit Level":
                    player.creature.stats.crit_level += 1;
                    points_spent++;
                    break;
                        
                case "Area of Effect":
                    player.creature.stats.aoe_damage += 1;
                    points_spent++;
                    break;
            }
    
            if (points_spent > 0) {
                // Remove used orbs
                var orbs_removed = 0;
                var i = 0;
                var required_type = stats_list[selected_stat].upgradeable_by;
                var items = player.creature.inventory.items;
                
                while (orbs_removed < points_spent && i < array_length(items)) {
                    if (items[i] != undefined && items[i].type == required_type) {
                        player.creature.inventory.remove_item(i);
                        orbs_removed++;
                    }
                    i++;
                }

                // Reset points spent
                points_spent = 0;
            }
        }
        
        // Close menu without spending points
        if (player.creature.input.menu_back) {
            upgrade_mode = false;
            stats_menu_active = false;
            points_spent = 0;
            instance_activate_all();
        }
    }
}