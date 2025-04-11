// obj_npc_parent Create Event (parent = obj_creature_parent)
event_inherited();  // Get creature stuff
is_npc = true;

// Initialize entity for component-based health system
entity = {};
entity.owner_instance = id;

// Unlike enemies, NPCs don't need detection range or targeting
