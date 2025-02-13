// obj_weapon_system Step Event
var aim_angle = 0;
var cd, i;

with(all) {
    if (!variable_instance_exists(id, "creature")) continue;
    
    // Update crit timer
    creature.stats.update_crit_timer();
    
    // Handle all cooldowns
    var cooldowns = [];
    array_push(cooldowns, "fireball_cooldown", "ghostball_cooldown", "shotgun_cooldown", "bomb_cooldown");
    
    for(i = 0; i < array_length(cooldowns); i++) {
        cd = cooldowns[i];
        if (variable_struct_exists(creature, cd)) {
            if (variable_struct_get(creature, cd) > 0) {
                variable_struct_set(creature, cd, variable_struct_get(creature, cd) - 1);
            }
        }
    }
    
    // Calculate aim angle
    if (creature.input.using_controller) {
        if (abs(creature.input.aim_x) > 0.2 || abs(creature.input.aim_y) > 0.2) {
            aim_angle = point_direction(0, 0, creature.input.aim_x, creature.input.aim_y);
        } else {
            aim_angle = (creature.facing_direction == "right") ? 0 : 180;
        }
    } else {
        aim_angle = point_direction(x, y, creature.input.target_x, creature.input.target_y);
    }
    
    // Check for shooting
    if (creature.input.fire) {
        with(other) {
            shoot_fireball(other, aim_angle);
        }
    }
    
    // Check for bomb throwing
    if (creature.input.alt_fire) {
        with(other) {
            shoot_bomb(other, aim_angle);
        }
    }
}