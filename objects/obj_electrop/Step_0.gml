event_inherited();
function apply_effect(target) {
    // This 'if' statement is the corrected line.
    if (variable_instance_exists(target, "entity") && variable_struct_exists(target.entity, "components") && variable_struct_exists(target.entity.components, "weapon")) {
        var weapon_data = { base_cooldown: 60, pickup_obj_index: object_index };
        return target.entity.weapon.pickup_weapon("electro", weapon_data);
    }
    return false;
}