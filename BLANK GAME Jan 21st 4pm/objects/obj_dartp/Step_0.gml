// obj_dartp Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.has_dart = true;
	target.creature.can_shoot_dart = true;
}