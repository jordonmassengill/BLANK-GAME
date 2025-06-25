// obj_player_creature_parent Create Event (parent = obj_creature_parent)
event_inherited(); // Get creature_parent stuff
is_player = true;

// FIX: Initialize the 'entity' and 'creature' structs in the parent object.
// This guarantees that any instance of this object or its children
// will have these variables, resolving the GM1041 error.
entity = {};
entity.owner_instance = id;
creature = create_player_properties();