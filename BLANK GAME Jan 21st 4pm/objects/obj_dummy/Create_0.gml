// obj_dummy Create Event (parent = obj_enemy_parent)
event_inherited();
creature = create_dummy_properties();

// Add health component
add_component(entity, "health", create_health_component(800)); // Base health for dummy

// Set health properties
entity.health.max_health = 800;
entity.health.current_health = 700; // Start with a bit less health for testing
