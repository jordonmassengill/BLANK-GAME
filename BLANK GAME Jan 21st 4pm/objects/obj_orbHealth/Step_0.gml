// obj_orb_health Step Event
event_inherited();

function apply_effect(target) {
    target.entity.health.max_health += 50;
    target.entity.health.current_health = target.entity.health.max_health;
}