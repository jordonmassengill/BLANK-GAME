// obj_weapon_system Step Event
var aim_angle = 0;
var cd, i;

with(all) {
	if (!variable_instance_exists(id, "creature")) continue;
	
	// Update crit timer
	creature.stats.update_crit_timer();
	
	// Handle all cooldowns
	var cooldowns = [];
	array_push(cooldowns, "fireball_cooldown", "ghostball_cooldown", "shotgun_cooldown", "bomb_cooldown", "dart_cooldown", "waterball_cooldown", "iceball_cooldown", "electro_cooldown", "ghoststrike_cooldown");
	
	for(i = 0; i < array_length(cooldowns); i++) {
		cd = cooldowns[i];
		if (variable_struct_exists(creature, cd)) {
			if (variable_struct_get(creature, cd) > 0) {
				variable_struct_set(creature, cd, variable_struct_get(creature, cd) - 1);
			}
		}
	}
	
	// --- FIX: Calculate aim angle based on controller or mouse, now compatible with both creature types ---
	if (creature.input.using_controller) {
		if (abs(creature.input.aim_x) > 0.2 || abs(creature.input.aim_y) > 0.2) {
			aim_angle = point_direction(0, 0, creature.input.aim_x, creature.input.aim_y);
		} else {
			// Check for player's new sprite_direction, fall back to old system for enemies
			var dir = variable_instance_exists(id, "sprite_direction") ? sprite_direction : (creature.facing_direction == "right" ? 1 : -1);
			aim_angle = (dir == 1) ? 0 : 180;
		}
	} else {
		aim_angle = point_direction(x, y, creature.input.target_x, creature.input.target_y);
	}
	// --- END FIX ---
	
	// Check for shooting
	if (creature.input.fire) {
		with(other) {
			shoot_fireball(other, aim_angle);
		}
	}
	
	if (creature.input.fire) {
		with(other) {
			shoot_dart(other, aim_angle);
		}
	}
	
	if (creature.input.fire) {
		with(other) {
			shoot_waterball(other, aim_angle);
		}
	}
			
	if (creature.input.fire) {
		with(other) {
			shoot_iceball(other, aim_angle);
		}
	}
	
	if (creature.input.fire) {
		with(other) {
			shoot_electro(other, aim_angle);
		}
	}
	
	if (creature.input.fire) {
		with(other) {
			shoot_ghoststrike(other, aim_angle);
		}
	}
	
	// Check for bomb throwing
	if (creature.input.alt_fire) {
		with(other) {
			shoot_bomb(other, aim_angle);
		}
	}
}
