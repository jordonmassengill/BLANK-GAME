//Create Event for obj_Finesseupgrade (parent = obj_pickup_parent)
finesseitem = {
    name: "Finesse Orb",
    color: make_colour_rgb(139, 69, 19),  // Brown color
    type: "finesse",  
    description: "Can be used to upgrade Crit Level"
}

function apply_effect(target) {
    if (variable_instance_exists(target, "creature") && 
        variable_struct_exists(target.creature, "inventory")) {
        // Add the item to inventory
        target.creature.inventory.add_item(finesseitem);
        // Return true so the object knows to destroy itself
        return true;
    }
    return false;
}