// The new, simplified Create Event for obj_jpack
event_inherited(); // Inherits from obj_pickup_parent

// Notice how this object no longer knows what a jetpack does.
// It only knows its own item ID.
function apply_effect(target) {
    return target.entity.inventory.add_item("pickup_jetpack");
}