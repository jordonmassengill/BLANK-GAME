//Create Event for obj_Lifeupgrade (parent = obj_pickup_parent)
lifeitem = {
    name: "Life Orb",
    color: c_red,  // This will be the color shown in inventory
    type: "life",  // We can use this later to determine what stats it can upgrade
    description: "Can be used to upgrade Health, Regen, or Life Steal"
}

function apply_effect(target) {
    if (variable_instance_exists(target, "creature") && 
        variable_struct_exists(target.creature, "inventory")) {
        // Add the item to inventory
        target.creature.inventory.add_item(lifeitem);
        // Return true so the object knows to destroy itself
        return true;
    }
    return false;
}