// obj_game_init Create Event
window_set_size(1440, 810);

// Initialize systems
instance_create_layer(0, 0, "instances", obj_pause_controller);
init_damage_numbers();  // Initialize damage number system first
global.health_system = create_health_system();
global.debug_visible = true;
//Stats menu
instance_create_layer(0, 0, "instances", obj_stats_menu);

// Create other controllers
create_debug_stats_controller();