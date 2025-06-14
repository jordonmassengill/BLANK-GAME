// obj_health_system Step Event
with(all) {
	// Skip objects without creature property or entity
	if (!variable_instance_exists(id, "creature") ||
		!variable_instance_exists(id, "entity") ||
		!variable_struct_exists(entity, "health")) continue;
	
	// Apply health regeneration
	if (variable_struct_exists(creature, "stats") && 
		variable_struct_exists(creature.stats, "health_regen") && 
		creature.stats.health_regen > 0) {
		
		var regen_amount = creature.stats.health_regen / 60; // convert per second to per step
		entity.health.heal(regen_amount);
	}
	
	// Handle contact damage and knockback for player
	if (variable_instance_exists(id, "is_player")) {
		// Check for cooldown property
		if (!variable_instance_exists(id, "damage_cooldown")) {
			id.damage_cooldown = 0;
		}
		
		if (id.damage_cooldown > 0) {
			id.damage_cooldown--;
		}
		
		if (id.damage_cooldown <= 0) {
			var collided_creature = instance_place(x, y, obj_enemy_parent);
			if (collided_creature != noone) {
				// Apply contact damage
				entity.health.take_damage(10);
				id.damage_cooldown = 30; // 0.5 second invulnerability
				
				// --- UPDATED KNOCKBACK LOGIC ---
				// Check for the new movement component
				if (variable_struct_exists(entity, "movement")) {
					var kb_dir = point_direction(collided_creature.x, collided_creature.y, x, y);
					var knock_h = lengthdir_x(3, kb_dir);
					var knock_v = min(-2, lengthdir_y(3, kb_dir));
					
					// Use the component's method to apply knockback
					entity.movement.apply_knockback(knock_h, knock_v);
				}
			}
		}
	}
	
	// Health-based death check is now handled by the component's death callback.
}
