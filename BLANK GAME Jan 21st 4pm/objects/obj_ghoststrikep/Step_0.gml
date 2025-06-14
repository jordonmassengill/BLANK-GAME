// obj_ghoststrike Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.has_ghoststrike = true;
	target.creature.can_shoot_ghoststrike = true;
}