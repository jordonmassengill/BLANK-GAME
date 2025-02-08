// Create Event for obj_Blankorb (parent = obj_pickup_parent)
blankitem = {
    name: "Blank Orb",
    color: c_gray,  // Gray color for inventory display
    type: "blank",  // Special type for blank orbs
    description: "Can be exchanged for any orb type at an exchange platform"
}

function apply_effect(target) {
    if (variable_instance_exists(target, "creature") && 
        variable_struct_exists(target.creature, "inventory")) {
        // Add the item to inventory
        target.creature.inventory.add_item(blankitem);
        // Return true so the object knows to destroy itself
        return true;
    }
    return false;
}