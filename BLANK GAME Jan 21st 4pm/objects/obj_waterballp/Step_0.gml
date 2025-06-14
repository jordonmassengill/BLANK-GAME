// obj_waterballp Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.has_waterball = true;
	target.creature.can_shoot_waterball = true;
}