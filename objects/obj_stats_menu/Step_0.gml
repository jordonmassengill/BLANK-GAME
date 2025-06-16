// obj_stats_menu Step Event
scanline_offset += 0.5;
if (scanline_offset >= 10) {
    scanline_offset = 0;
}

var player = instance_find(obj_player_creature_parent, 0);
if (!player) {
    exit;
}

// Handle menu toggling with TAB or controller button
if (player.creature.input.stats_menu_pressed) {
	
	// Case 1: The menu is already active, so we need to CLOSE it.
	if (stats_menu_active) {
		stats_menu_active = false;
		upgrade_mode = false; // Also reset upgrade mode if it was active
		target_player = noone; // Clear the stored player reference
		instance_activate_all();
		player.entity.movement.force_state_re_evaluation();

	}
	// Case 2: The menu is not active, so this is a request to OPEN it.
	else {
		// ✅ Run our safety check BEFORE opening the menu.
		if (variable_instance_exists(player, "entity")) {
			
			// If the player is ready, store the reference and activate the menu.
			target_player = player;
			stats_menu_active = true;
			
			instance_deactivate_all(true);
			instance_activate_object(obj_stats_menu);
			instance_activate_object(obj_input_manager);
			instance_activate_object(player);
		}
		// If the safety check fails (player not ready), we simply do nothing.
	}
}

// Only process the rest of the logic if the menu is active
if (stats_menu_active) {
    
    // --- Menu Navigation ---
    if (player.creature.input.menu_up) {
        selected_stat--;
        if (selected_stat < 0) {
            selected_stat = array_length(stats_list) - 1;
        }
    }
    
    if (player.creature.input.menu_down) {
        selected_stat++;
        if (selected_stat >= array_length(stats_list)) {
            selected_stat = 0;
        }
    }

    // --- Handle Upgrade Logic (only if on an upgrade platform) ---
    if (upgrade_mode) {
        var creature = player.creature;
        var selected = stats_list[selected_stat];
        var upgrade_type = selected.upgradeable_by;

        // Use our new helper to count points easily!
        var available_points = player.entity.inventory.count_item(upgrade_type);

        // Check for upgrade confirmation
        if (player.creature.input.menu_select && available_points > points_spent) {
            
            // This switch statement handles applying the actual stat boost
            switch (selected.name) {
                // Life upgrades
                case "Max Health":
                    player.entity.health.max_health += 50;
                    player.entity.health.current_health += 50;
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

                // Finesse upgrades
                case "Crit Level":
                    player.creature.stats.crit_level += 1;
                    points_spent++;
                    break;
                            
                case "Area of Effect":
                    player.creature.stats.aoe_damage += 1;
                    player.creature.stats.aoe_radius += 0.25;
                    points_spent++;
                    break;
            }
    
            // If any points were spent, consume the orbs from inventory
            if (points_spent > 0) {
                // Use our new helper to consume the orbs!
                // No more complex loops needed here.
                for (var i = 0; i < points_spent; i++) {
                    player.entity.inventory.consume_item(upgrade_type);
                }
                
                // Reset for the next transaction
                points_spent = 0;
            }
        }
        
        // Handle closing the menu while in upgrade mode
        if (player.creature.input.menu_back) {
            upgrade_mode = false;
            stats_menu_active = false;
            points_spent = 0;
            instance_activate_all();
			player.entity.movement.force_state_re_evaluation();

        }
    }
}