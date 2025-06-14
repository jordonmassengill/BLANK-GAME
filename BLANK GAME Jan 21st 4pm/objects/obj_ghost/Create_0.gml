// obj_ghost Create Event (parent = obj_enemy_parent)
event_inherited();
creature = create_ghost_properties();

// Add health component
add_component(entity, "health", create_health_component(200)); // Base health for ghost

// Set health properties from creature stats if needed
entity.health.max_health = 200;
entity.health.current_health = 200;
