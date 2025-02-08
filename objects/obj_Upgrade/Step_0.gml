// obj_upgrade Step Event
var player = instance_place(x, y - 1, obj_player_creature_parent);
if (player != noone) {
    var platform_center = x;
    var player_center = player.x;
    var center_threshold = 10;
    var is_centered = abs(platform_center - player_center) <= center_threshold;

    if (is_centered && !is_player_on_platform) {
        is_player_on_platform = true;
        
        var stats_menu = instance_find(obj_stats_menu, 0);
        if (stats_menu == noone) {
            stats_menu = instance_create_layer(0, 0, "Instances", obj_stats_menu);
        }
        
        if (stats_menu != noone && !stats_menu.stats_menu_active && !has_opened_menu) {
            stats_menu.stats_menu_active = true;
            stats_menu.upgrade_mode = true;
            has_opened_menu = true;
            instance_deactivate_all(true);
            instance_activate_object(stats_menu);
            instance_activate_object(obj_input_manager);
            instance_activate_object(obj_player_creature_parent);
        }
    }
} else {
    is_player_on_platform = false;
    has_opened_menu = false;
}