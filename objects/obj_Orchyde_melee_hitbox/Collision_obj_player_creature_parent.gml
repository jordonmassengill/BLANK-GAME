// File: objects/obj_Orchyde_melee_hitbox/Collision_obj_player_creature_parent.gml

if (!has_hit && other.id != creator) {
	// Check if the 'other' instance has an 'entity' variable AND that variable is a struct.
	// This is the most robust check and resolves the GM1041 error.
	if (variable_instance_exists(other, "entity") && is_struct(other.entity)) {
		
		var _entity = other.entity; // Store the struct in a local variable for safe access.

		has_hit = true;
	
		// Apply damage via the health component, if it exists on the entity.
		if (variable_struct_exists(_entity, "health")) {
			_entity.health.take_damage(damage);
		}
	
		// Apply knockback via the movement component, if it exists on the entity.
		if (variable_struct_exists(_entity, "movement")) {
			var knock_dir = point_direction(creator.x, creator.y, other.x, other.y);
			
			var knock_h = lengthdir_x(knockback_force, knock_dir);
			var knock_v = lengthdir_y(knockback_force * 2, knock_dir);
			
			// Ensure some upward movement for better feel
			if (knock_v > -2) knock_v = -2;
			
			// Use the component's method to apply knockback correctly
			_entity.movement.apply_knockback(knock_h, knock_v);
		}
		
		// The hitbox has done its job and can be destroyed.
		instance_destroy();
	}
}