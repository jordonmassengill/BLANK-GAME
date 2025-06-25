// obj_npc_parent Create Event (parent = obj_creature_parent)
event_inherited(); // Get creature_parent stuff
is_npc = true;

// Initialize entity for component-based health system
entity = {};
entity.owner_instance = id;

// FIX: Initialize the 'creature' struct here to satisfy the analyzer.
// Child objects like obj_Martin will overwrite this with their specific properties.
creature = create_creature_properties();