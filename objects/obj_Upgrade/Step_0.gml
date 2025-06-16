// Find if a player is standing just above the platform
var player = instance_place(x, y - 1, obj_player_creature_parent);

// If a player is detected...
if (player != noone) {
    // Check if the player is roughly centered on the platform
    var platform_center = x;
    var player_center = player.x;
    var center_threshold = 10;
    var is_centered = abs(platform_center - player_center) <= center_threshold;

    // If the player is centered and we haven't already opened the menu for them...
    if (is_centered && !is_player_on_platform) {
        is_player_on_platform = true; // Mark that a player is now on the platform

        var stats_menu = instance_find(obj_stats_menu, 0);

        // Check if the menu object exists and can be opened
        if (stats_menu != noone && !stats_menu.stats_menu_active && !has_opened_menu) {
            
            // ✅ CRUCIAL FIX: Verify the player is fully initialized before proceeding.
            // This prevents the race condition crash.
            if (!variable_instance_exists(player, "entity")) {
                exit; // Player is not ready, do not open the menu. End script for this frame.
            }

            // Player is ready, so open the menu and give it the player's id
            stats_menu.target_player = player; // <-- Store the valid player reference
            stats_menu.stats_menu_active = true;
            stats_menu.upgrade_mode = true;
            has_opened_menu = true;
            
            // Pause the game by deactivating everything else
            instance_deactivate_all(true);
            
            // And then reactivating only the essential instances for the menu to work
            instance_activate_object(stats_menu);
            instance_activate_object(obj_input_manager);
            instance_activate_object(player);
        }
    }
} 
// If no player is on the platform...
else {
    // Reset the flags so the menu can be opened again next time
    is_player_on_platform = false;
    has_opened_menu = false;
}