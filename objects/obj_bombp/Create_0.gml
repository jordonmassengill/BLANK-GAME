event_inherited();

function apply_effect(target) {
    // Revert to the original, more robust check to ensure all parts of the entity exist.
    if (variable_instance_exists(target, "entity") && 
        variable_struct_exists(target.entity, "components") && 
        variable_struct_exists(target.entity.components, "weapon")) {
        
        // Keep the new, correct function call inside the safe block.
        return target.entity.weapon.pickup_weapon("bomb", object_index);
    }
    return false;
}