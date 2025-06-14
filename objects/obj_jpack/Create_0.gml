// This is a new Create Event for obj_jpack.
// We define the apply_effect method here, which is much more efficient
// than defining it in the Step Event every frame.

apply_effect = function(target) {
    // Check if the target already has a jetpack to avoid adding fuel unnecessarily
    // if it's just a visual pickup. For now, we'll assume it always adds fuel.
    target.creature.has_jetpack = true;
    
    // Use the global macro for a clean, maintainable value
    target.creature.jetpack_fuel += JETPACK_FUEL_PICKUP_AMOUNT;
}
