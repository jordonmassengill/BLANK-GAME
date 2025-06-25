// obj_creature_parent Step Event
if (variable_instance_exists(id, "creature")) {
    // Update all active effects
    creature.status_manager.update_effects(id);
	
	    if (!instance_exists(id)) {
        exit;
    }
    
    // Apply movement speed effects if slowed
    var move_slow = creature.status_manager.get_effect_magnitude(STATUS_TYPE.MOVEMENT_SLOW);
    if (move_slow > 0) {
        creature.stats.speed_bonus = -(creature.stats.move_speed * move_slow);
    } else {
        creature.stats.speed_bonus = 0;  // Reset when not slowed
    }
    
    // Apply attack speed slow
    var attack_slow = creature.status_manager.get_effect_magnitude(STATUS_TYPE.ATTACK_SLOW);
    if (attack_slow > 0) {
        creature.stats.rof_bonus = -(creature.stats.rate_of_fire * attack_slow);
    } else {
        creature.stats.rof_bonus = 0;  // Reset when not slowed
    }
    
    // Handle stun
    if (creature.status_manager.has_effect(STATUS_TYPE.STUN)) {
        // Prevent movement and actions while stunned
        creature.input.left = false;
        creature.input.right = false;
        creature.input.jump = false;
        creature.input.fire = false;
    }
}

if (variable_instance_exists(id, "entity") && entity.has_component("health")) {
    entity.health.update();
}