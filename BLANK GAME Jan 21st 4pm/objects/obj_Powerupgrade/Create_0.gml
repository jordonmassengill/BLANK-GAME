//Create Event for obj_Powerupgrade (parent = obj_pickup_parent)
poweritem = {
    name: "Power Orb",
    color: c_blue,  // This will be the color shown in inventory
    type: "power",  // We can use this later to determine what stats it can upgrade
    description: "Can be used to upgrade Physical, Magical, or AoE"
}

function apply_effect(target) {
    if (variable_instance_exists(target, "creature") && 
        variable_struct_exists(target.creature, "inventory")) {
        // Add the item to inventory
        target.creature.inventory.add_item(poweritem);
        // Return true so the object knows to destroy itself
        return true;
    }
    return false;
}