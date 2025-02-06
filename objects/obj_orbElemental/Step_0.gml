// obj_orbElemental Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.stats.elemental_power_bonus += 1.0;
}