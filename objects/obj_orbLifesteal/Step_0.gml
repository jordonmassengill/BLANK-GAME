// obj_orborange Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.stats.life_steal += 0.1;
}