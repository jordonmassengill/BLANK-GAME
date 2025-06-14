// obj_iceball Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.has_iceball = true;
	target.creature.can_shoot_iceball = true;
}