// The new, simplified Create Event for obj_Lifeupgrade

// This is all the logic we need now!
function apply_effect(target) {
    // Just tell the target's inventory to add a "life_orb"
    // The inventory component itself knows what that means.
    return target.entity.inventory.add_item("orb_life");
}