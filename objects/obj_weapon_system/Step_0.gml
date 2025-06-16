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
        
        // --- This is the NEW code ---
if (_input.fire) {
    entity.weapon.fire(); // No arguments for the player
}

// The alt_fire logic in the weapon component doesn't exist yet,
// so we'll comment this out for now to prevent future errors.
/*
if (_input.alt_fire) {
    entity.weapon.fire(); 
}
*/
    }
}