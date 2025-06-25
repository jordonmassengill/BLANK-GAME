// obj_game_init Create Event
window_set_size(1920, 1080);

// Initialize systems
instance_create_layer(0, 0, "Instances", obj_pause_controller);
instance_create_layer(0, 0, "Instances", obj_stats_menu);
instance_create_layer(0, 0, "Instances", obj_combat_interaction_system); // <-- THIS IS THE FIX

init_damage_numbers();  // Initialize damage number system first
global.debug_visible = true;

// Create other controllers
create_debug_stats_controller();