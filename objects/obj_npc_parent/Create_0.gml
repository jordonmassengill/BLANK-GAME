// obj_npc_parent Create Event (parent = obj_creature_parent)
event_inherited();  // Get creature stuff
is_npc = true;

// Initialize entity for component-based health system
entity = {};
entity.owner_instance = id;

add_component(entity, "status", create_status_component(entity)); // <-- ADD THIS LINE
