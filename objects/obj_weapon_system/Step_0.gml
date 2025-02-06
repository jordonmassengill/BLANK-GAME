// Step Event for obj_weapon_system
// Declare variables outside with statement
var aim_angle = 0;
var cd, i;  // Declare loop variables outside too
with(all) {
    if (!variable_instance_exists(id, "creature")) continue;

    // Handle all cooldowns - using GML array
    var cooldowns = [];
    array_push(cooldowns, "fireball_cooldown", "ghostball_cooldown", "shotgun_cooldown");

    for(i = 0; i < array_length(cooldowns); i++) {
        cd = cooldowns[i];
        if (variable_struct_exists(creature, cd)) {  // Changed to struct_exists
            if (variable_struct_get(creature, cd) > 0) {  // Use proper GML struct access
                variable_struct_set(creature, cd, variable_struct_get(creature, cd) - 1);
            }
        }
    }

    // Calculate aim angle
    if (creature.input.using_controller) {
        // For controller, check if sticks are being used
        if (abs(creature.input.aim_x) > 0.2 || abs(creature.input.aim_y) > 0.2) {
            aim_angle = point_direction(0, 0, creature.input.aim_x, creature.input.aim_y);
        } else {
            // If sticks are neutral, shoot based on facing direction
            aim_angle = (creature.facing_direction == "right") ? 0 : 180;
        }
    } else {
        // Mouse aiming
        aim_angle = point_direction(x, y, creature.input.target_x, creature.input.target_y);
    }

    // Check for shooting
    if (creature.input.fire) {
        with(other) {
            shoot_fireball(other, aim_angle);
        }
    }
}