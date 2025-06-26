// File: objects/obj_pickup_parent/Create_0.gml
// Initialize the cooldown timer for this pickup
pickup_cooldown = 0;

function apply_effect(target) {
    
    // --- Weapon Pickup Logic (This part is already correct) ---
    if (variable_instance_exists(id, "weapon_id_to_give")) {
        if (variable_instance_exists(target, "entity") && 
            variable_struct_exists(target.entity, "components") && 
            variable_struct_exists(target.entity.components, "weapon")) {
            
            return target.entity.weapon.pickup_weapon(weapon_id_to_give, object_index);
        }
        return false;
    }
    
    // --- Orb Pickup Logic (This is the fixed part) ---
    if (variable_instance_exists(id, "orb_id_to_give")) {
        
        // This is the more robust check that avoids the race condition.
        if (variable_instance_exists(target, "entity") && 
            variable_struct_exists(target.entity, "components") && 
            variable_struct_exists(target.entity.components, "inventory")) {
                
            return target.entity.inventory.add_item(orb_id_to_give);
        }
        return false;
    }
    
    // If the pickup is neither a weapon nor an orb, do nothing.
    return false;
}