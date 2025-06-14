// obj_bombp Create Event (parent = obj_pickup_parent)
function apply_effect(target) {
    if (variable_instance_exists(target, "creature")) {
        target.creature.has_bomb = true;
        target.creature.can_throw_bomb = true;
        target.creature.bomb_cooldown = 0;
        return true;
    }
    return false;
}