//obj_Orchyde_melee_hitbox Collision Event with obj_player_creature_parent
if (!has_hit && other.id != creator) {
	has_hit = true;
	
	// Apply damage via the health component
	if (variable_instance_exists(other, "entity") && variable_struct_exists(other.entity, "health")) {
		other.entity.health.take_damage(damage);
	}
	
	// --- UPDATED KNOCKBACK LOGIC ---
	// Check if the player has the new movement component
	if (variable_instance_exists(other, "entity") && variable_struct_exists(other.entity, "movement")) {
		var knock_dir = point_direction(creator.x, creator.y, other.x, other.y);
		
		var knock_h = lengthdir_x(knockback_force, knock_dir);
		var knock_v = lengthdir_y(knockback_force * 2, knock_dir);
		
		// Ensure some upward movement for better feel
		if (knock_v > -2) knock_v = -2;
		
		// Use the component's method to apply knockback correctly
		other.entity.movement.apply_knockback(knock_h, knock_v);
	}
	// --- END UPDATED KNOCKBACK ---
	
	instance_destroy();
}
