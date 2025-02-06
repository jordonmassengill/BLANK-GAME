// obj_orbMagicalpower Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.stats.magical_damage_bonus += 1;
}