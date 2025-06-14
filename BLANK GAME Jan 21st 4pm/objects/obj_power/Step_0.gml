// obj_power Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.has_fireball = true;
	target.creature.can_shoot_fireball = true;
}