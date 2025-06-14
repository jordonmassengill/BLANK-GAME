// obj_ghost Create Event (parent = obj_enemy_parent)
event_inherited();
creature = create_ghost_properties();

// Add health component
add_component(entity, "health", create_health_component(200)); // Base health for ghost

// Set health properties from creature stats if needed
entity.health.max_health = 200;
entity.health.current_health = 200;

// Weapon Component to Ghost ---
var weapon_comp = create_weapon_component(entity);
// Use pickup_weapon instead of add_weapon
var weapon_data = { base_cooldown: 300, pickup_obj_index: undefined };
weapon_comp.pickup_weapon("ghostball", weapon_data);
add_component(entity, "weapon", weapon_comp);