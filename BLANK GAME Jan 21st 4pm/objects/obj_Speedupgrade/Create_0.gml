//Create Event for obj_Speedupgrade (parent = obj_pickup_parent)
speeditem = {
    name: "Speed Orb",
    color: c_green,  // This will be the color shown in inventory
    type: "speed",  // We can use this later to determine what stats it can upgrade
    description: "Can be used to upgrade Movement, Rate of Fire, and Projectile Speed and Distance"
}

function apply_effect(target) {
    if (variable_instance_exists(target, "creature") &&  
        variable_struct_exists(target.creature, "inventory")) {
        // Add the item to inventory
        target.creature.inventory.add_item(speeditem);
        // Return true so the object knows to destroy itself
        return true;
    }
    return false;
}