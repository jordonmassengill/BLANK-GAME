// obj_electrop Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.has_electro = true;
	target.creature.can_shoot_electro = true;
}