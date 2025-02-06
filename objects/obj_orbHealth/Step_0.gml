// obj_orb_health Step Event
event_inherited();

function apply_effect(target) {
    target.creature.max_health += 50;
    target.creature.current_health = target.creature.max_health;
}