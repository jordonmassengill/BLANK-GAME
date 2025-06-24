// scr_enemy_properties.gml
function create_enemy_properties() {
	var props = create_creature_properties();
	
	// --- FIX: Re-initialize the state machine for enemies ---
	props.state_machine = create_state_machine();
	props.state_machine.init(props);
	
	// --- FIX: Add back movement variables for legacy enemies ---
	props.xsp = 0;
	props.ysp = 0;
	props.facing_direction = "right"; // Add this back
	// --- END FIX ---
	
	// Add enemy-specific properties
	props.respawn_on_death = false;  // Enemies typically don't respawn
	props.is_hostile = true;         // Flag for enemy behavior
	props.detection_range = 200;     // Example enemy-specific property
	props.aggro_range = 150;         // Example enemy-specific property
	props.is_enemy = true;           // Flag to identify as enemy
	
	// Combat properties
	props.melee_cooldown = 0;
	props.melee_cooldown_max = 60;   // 1 second cooldown for melee attacks
	props.is_melee_attacking = false;
	props.is_shooting = false;
	props.closest_target = noone;    // Reference to closest target
	props.closest_distance = 0;      // Distance to closest target
	props.distance_to_player = 0;    // Specific distance to player
	
	// Movement and patrol properties
	props.is_patrolling = true;
	props.patrol_point_left = 0;     // Will be set in specific enemy creation
	props.patrol_point_right = 0;    // Will be set in specific enemy creation
	props.moving_right = true;
	props.patrol_wait_time = 0;      // For enemies that pause at patrol endpoints
	props.edge_check_dist = 32;      // How far ahead to check for edges
	
	// Currency properties
	props.currency_value = 10;       // Base currency value
	
	// Health System
	props.max_health = 100;          // Enemies are weaker
	props.current_health = 100;
	
	// Replace state enum with state machine states
	setup_enemy_states(props);
	
	// Start in patrolling state
	props.state_machine.change_state("PATROL");
	
	return props;
}

// Helper function to set up enemy-specific states
// This function remains unchanged, but will now work correctly.
function setup_enemy_states(props) {
	// PATROL state
	props.state_machine.add_state("PATROL", 
		method(props, function() {
			// On enter patrol
			is_patrolling = true;
		}),
		method(props, function() {
			// Update patrol behavior
			
			// Simple left-right movement with edge detection
			if (moving_right) {
				xsp = stats.get_move_speed() * 0.5; // Half speed for patrol
				facing_direction = "right";
				
				// Check for edge or patrol point boundary
				var has_floor_ahead = position_meeting(
					owner.x + edge_check_dist, 
					owner.y + owner.sprite_height + 2, 
					obj_floor
				);
				
				if (!has_floor_ahead || owner.x >= patrol_point_right) {
					moving_right = false;
					facing_direction = "left";
				}
			} else {
				xsp = -stats.get_move_speed() * 0.5; // Half speed for patrol
				facing_direction = "left";
				
				// Check for edge or patrol point boundary
				var has_floor_ahead = position_meeting(
					owner.x - edge_check_dist, 
					owner.y + owner.sprite_height + 2, 
					obj_floor
				);
				
				if (!has_floor_ahead || owner.x <= patrol_point_left) {
					moving_right = true;
					facing_direction = "right";
				}
			}
			
			// Check for player/NPC in detection range
			var player = instance_nearest(owner.x, owner.y, obj_player_creature_parent);
			var npc = instance_nearest(owner.x, owner.y, obj_npc_parent);
			
			var detected_target = noone;
			var closest_dist = detection_range;
			
			// Check player distance
			if (player != noone) {
				var player_dist = point_distance(owner.x, owner.y, player.x, player.y);
				if (player_dist < closest_dist) {
					closest_dist = player_dist;
					detected_target = player;
				}
			}
			
			// Check NPC distance
			if (npc != noone) {
				var npc_dist = point_distance(owner.x, owner.y, npc.x, npc.y);
				if (npc_dist < closest_dist) {
					closest_dist = npc_dist;
					detected_target = npc;
				}
			}
			
			// If target detected, transition to chase
			if (detected_target != noone) {
				closest_target = detected_target;
				closest_distance = closest_dist;
				state_machine.change_state("CHASE");
			}
		})
	);
	
	// CHASE state
	props.state_machine.add_state("CHASE", 
		method(props, function() {
			// On enter chase
			is_patrolling = false;
		}),
		method(props, function() {
			// Update chase behavior
			if (closest_target == noone) {
				// Return to patrol if no target
				state_machine.change_state("PATROL");
				return;
			}
			
			// Update distance to target
			closest_distance = point_distance(
				owner.x, owner.y, 
				closest_target.x, closest_target.y
			);
			
			// Check if target is still in range
			if (closest_distance > detection_range) {
				closest_target = noone;
				state_machine.change_state("PATROL");
				return;
			}
			
			// Update facing direction
			facing_direction = (closest_target.x > owner.x) ? "right" : "left";
			
			// Check for melee attack range
			if (closest_distance < owner.sprite_width + 10) {
				state_machine.change_state("MELEE_ATTACK");
				return;
			}
			
			// Check for ranged attack if enemy can shoot
			if (variable_struct_exists(self, "can_shoot_ghostball") && 
				can_shoot_ghostball && 
				ghostball_cooldown <= 0 &&
				closest_distance < detection_range * 0.8) {
				state_machine.change_state("RANGED_ATTACK");
				return;
			}
			
			// Move toward target
			var move_dir = (closest_target.x > owner.x) ? 1 : -1;
			
			// Check for floor ahead before moving
			var check_x = owner.x + (move_dir * edge_check_dist);
			var has_floor_ahead = position_meeting(
				check_x, 
				owner.y + owner.sprite_height + 2, 
				obj_floor
			);
			
			if (has_floor_ahead) {
				xsp = move_dir * stats.get_move_speed();
			} else {
				// Stop at ledge
				xsp = 0;
			}
		})
	);
	
	// MELEE_ATTACK state
	props.state_machine.add_state("MELEE_ATTACK", 
		method(props, function() {
			// On enter melee attack
			is_melee_attacking = true;
			xsp = 0; // Stop movement during attack
			melee_cooldown = melee_cooldown_max;
			
			// Create melee hitbox if this enemy has one
			if (variable_struct_exists(self, "melee_hitbox_obj")) {
				var hitbox_offset = (facing_direction == "right") ? 20 : -20;
				var hitbox = instance_create_layer(
					owner.x + hitbox_offset,
					owner.y - 16,
					"Instances",
					melee_hitbox_obj
				);
				
				if (hitbox != noone) {
					hitbox.creator = owner;
					hitbox.damage = melee_damage;
					hitbox.life_time = 15;
				}
			}
		}),
		method(props, function() {
			// Update melee attack
			// Most implementation happens in animation events
			// Just need to check when to end the state
			
			melee_cooldown--;
			
			// Transition back to chase after cooldown period
			if (melee_cooldown <= 0) {
				is_melee_attacking = false;
				state_machine.change_state("CHASE");
			}
		})
	);
	
	// RANGED_ATTACK state
	props.state_machine.add_state("RANGED_ATTACK", 
		method(props, function() {
			// On enter ranged attack
			is_shooting = true;
			xsp = 0; // Stop movement during attack
			
			// Shoot in direction of target
			if (closest_target != noone) {
				var dir = point_direction(
					owner.x, owner.y,
					closest_target.x, closest_target.y
				);
				
				// Use the weapon system to fire
				with(obj_weapon_system) {
					if (variable_struct_exists(other, "can_shoot_ghostball") && other.can_shoot_ghostball) {
						shoot_ghostball(other.owner, dir);
					} else if (variable_struct_exists(other, "has_shotgun") && other.has_shotgun) {
						shoot_shotgun(other.owner, dir);
					}
				}
			}
		}),
		method(props, function() {
			// Just wait to transition back - animation controlled
			state_machine.change_state("CHASE");
		})
	);
	
	// HIT state - when enemy gets hit
	props.state_machine.add_state("HIT", 
		method(props, function() {
			// On enter hit state
			xsp = 0;
			hit_timer = hit_timer_max;
		}),
		method(props, function() {
			// Decrement timer and transition back when done
			hit_timer--;
			
			if (hit_timer <= 0) {
				// Go back to chase if player still in range
				if (closest_target != noone && 
					closest_distance <= detection_range) {
					state_machine.change_state("CHASE");
				} else {
					state_machine.change_state("PATROL");
				}
			}
		})
	);
	
	// DEAD state
	props.state_machine.add_state("DEAD", 
		method(props, function() {
			// On enter dead state
			xsp = 0;
			ysp = 0;
			
			// Give currency to player
			var player = instance_find(obj_player_creature_parent, 0);
			if (player != noone) {
				player.creature.currency += currency_value;
			}
			
			// Create death effect
			// (This would be done by specific enemy types)
		}),
		method(props, function() {
			// Just wait to be destroyed - animation controlled
		})
	);
}
