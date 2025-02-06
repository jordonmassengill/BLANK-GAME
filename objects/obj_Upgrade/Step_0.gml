// obj_upgrade_platform Step Event
var player = instance_place(x, y - 1, obj_player_creature_parent);

if (player != noone) {
    // Calculate centers
    var platform_center = x + (sprite_width / 2);
    var player_center = player.x + (player.sprite_width / 2);
    var center_threshold = 10;  // Adjust this to make the center detection more or less forgiving
    
    // Check if player is centered on platform
    var is_centered = abs(platform_center - player_center) <= center_threshold;
    
    if (is_centered && !is_player_on_platform) {
        is_player_on_platform = true;
        show_debug_message("Player detected on platform center");
        
        // Check if stats menu exists
        var stats_menu = instance_find(obj_stats_menu, 0);
        if (stats_menu == noone) {
            show_debug_message("Creating stats menu");
            stats_menu = instance_create_layer(0, 0, "Instances", obj_stats_menu);
        }
        
        if (stats_menu != noone) {
            show_debug_message("Found/Created stats menu object");
            if (!stats_menu.stats_menu_active && !has_opened_menu) {
                show_debug_message("Opening stats menu in upgrade mode");
                stats_menu.stats_menu_active = true;
                stats_menu.upgrade_mode = true;
                has_opened_menu = true;
                show_debug_message("Deactivating instances...");
                instance_deactivate_all(true);
                instance_activate_object(stats_menu);
                instance_activate_object(obj_input_manager);
                instance_activate_object(obj_player_creature_parent);
                show_debug_message("Done with menu activation");
            }
        } else {
            show_debug_message("Failed to create/find stats menu!");
        }
    }
} else {
    is_player_on_platform = false;
    has_opened_menu = false;
}