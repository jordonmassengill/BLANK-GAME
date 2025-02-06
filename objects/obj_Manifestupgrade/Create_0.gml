//Create Event for obj_Manifestupgrade (parent = obj_pickup_parent)
manifestitem = {
    name: "Manifest Orb",
    color: c_orange,  // This will be the color shown in inventory
    type: "manifest",  // We can use this later to determine what stats it can upgrade
    description: "Can be used to upgrade Elemental, Faith, and Artifacts."
}

function apply_effect(target) {
    if (variable_instance_exists(target, "creature") && 
        variable_struct_exists(target.creature, "inventory")) {
        // Add the item to inventory
        target.creature.inventory.add_item(manifestitem);
        // Return true so the object knows to destroy itself
        return true;
    }
    return false;
}