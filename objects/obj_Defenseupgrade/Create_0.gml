//Create Event for obj_Defenseupgrade (parent = obj_pickup_parent)
defenseitem = {
    name: "Defense Orb",
    color: c_purple,  // This will be the color shown in inventory
    type: "defense",  // We can use this later to determine what stats it can upgrade
    description: "Can be used to upgrade Armor, Restistance, and Reflect."
}

function apply_effect(target) {
    if (variable_instance_exists(target, "creature") && 
        variable_struct_exists(target.creature, "inventory")) {
        // Add the item to inventory
        target.creature.inventory.add_item(defenseitem);
        // Return true so the object knows to destroy itself
        return true;
    }
    return false;
}