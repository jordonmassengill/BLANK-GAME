// obj_movement_system Step Event
with(all) {
    if (!variable_instance_exists(id, "creature")) continue;
    
    // --- NEW: MOVEMENT COMPONENT LOGIC ---
    if (variable_instance_exists(id, "entity") && variable_struct_exists(entity, "movement")) {
        // This object (e.g., obj_guy) uses the new component system.
        // The component has already calculated xsp and ysp.
        // We just need to apply the movement and handle collisions.
        
        // Horizontal Collision
        if (place_meeting(x + creature.xsp, y, obj_floor)) {
            while(!place_meeting(x + sign(creature.xsp), y, obj_floor)) {
                x += sign(creature.xsp);
            }
            creature.xsp = 0;
        }
        x += creature.xsp;

        // Vertical Collision
        if (place_meeting(x, y + creature.ysp, obj_floor)) {
            while(!place_meeting(x, y + sign(creature.ysp), obj_floor)) {
                y += sign(creature.ysp);
            }
            creature.ysp = 0;
        }
        y += creature.ysp;

        continue; // Skip to the next instance
    }
    
    // --- LEGACY MOVEMENT LOGIC (for enemies, etc.) ---
    // This part remains unchanged to ensure enemies are not affected yet.
	if (variable_struct_exists(creature, "state_machine")) {
		// This handles state-machine based enemies that do not have the new component
		// This code remains exactly as it was.
		if (creature.xsp != 0) {
            var steps = abs(creature.xsp);
            var dir = sign(creature.xsp);
            for (var i = 0; i < steps; i++) {
                if (!place_meeting(x + dir, y, obj_floor)) {
                    x += dir;
                } else {
                    break;
                }
            }
        }
        if (creature.ysp != 0) {
            // This part of your original code used move_and_collide, which is fine
            // We'll keep it as-is for legacy entities
            move_and_collide(0, creature.ysp, obj_floor);
        }
		continue;
	}
    
    // The rest of the legacy movement code...
    // ... (This section is omitted for brevity but would be the original code)
}
