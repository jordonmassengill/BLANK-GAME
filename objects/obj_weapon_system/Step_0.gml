// obj_weapon_system Step Event - REVISED AND FINAL (V2)

// Loop through all instances in the room once.
with(all) {
    // First, check if the instance is a creature. If not, skip it.
    if (!variable_instance_exists(id, "creature")) {
        continue;
    }
    
    // Always update the crit timer for any creature.
    creature.stats.update_crit_timer();
    
    // --- NEW FIRING LOGIC ---
    // Now, check if this creature also has our new weapon component using a more direct check.
    if (variable_instance_exists(id, "entity") &&
        variable_struct_exists(entity, "components") &&
        variable_struct_exists(entity.components, "weapon")) {
        
        var _input = creature.input;
        
        // If fire is pressed, tell the component to fire its primary weapon.
        if (_input.fire) {
            entity.weapon.fire("primary");
        }
        
        // If alt_fire is pressed, tell the component to fire its secondary weapon.
        if (_input.alt_fire) {
            entity.weapon.fire("secondary");
        }
    }
}