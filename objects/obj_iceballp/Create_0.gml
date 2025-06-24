// Now that the object has its variables, we can define its unique ability.
function apply_effect(target) {
    if (variable_instance_exists(target, "entity") && variable_struct_exists(target.entity, "components") && variable_struct_exists(target.entity.components, "weapon")) {
        var weapon_data = { base_cooldown: 15, pickup_obj_index: object_index };
        return target.entity.weapon.pickup_weapon("iceball", weapon_data);
    }
    return false;
}