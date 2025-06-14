// obj_jpack Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.has_jetpack = true;
	target.creature.jetpack_fuel += JETPACK_FUEL;
}