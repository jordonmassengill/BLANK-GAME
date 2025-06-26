// File: objects/obj_pickup_parent/Create_0.gml

// Initialize the cooldown timer for this pickup
pickup_cooldown = 0;

// This is the new, corrected function in obj_pickup_parent's Create Event.
// You can replace the previous debug version with this one.

function apply_effect(target) {
    
    // Check if this pickup is meant to give a weapon
    if (variable_instance_exists(id, "weapon_id_to_give")) {
        
        // --- START OF FIX ---
        // This is a more direct and robust way to check if the player is ready.
        // It avoids the race condition by checking for the structs themselves.
        if (variable_instance_exists(target, "entity") && 
            variable_struct_exists(target.entity, "components") && 
            variable_struct_exists(target.entity.components, "weapon")) {
            
            // Success! The player is fully initialized.
            return target.entity.weapon.pickup_weapon(weapon_id_to_give, object_index);
            
        } else {
            // The player isn't ready yet. Fail gracefully and try again next frame.
            return false;
        }
        // --- END OF FIX ---
    }
    
    // This part is for non-weapon pickups, which will have their own apply_effect functions.
    return false;
}