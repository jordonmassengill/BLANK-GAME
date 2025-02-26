// scr_enemy_properties.gml
function create_enemy_properties() {
    var props = create_creature_properties();
    
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
function setup_enemy_states(enemy) {
    // PATROL state
    enemy.state_machine.add_state("PATROL", 
        function() {
            // On enter patrol
            enemy.is_patrolling = true;
        },
        function() {
            // Update patrol behavior
            
            // Simple left-right movement with edge detection
            if (enemy.moving_right) {
                enemy.xsp = enemy.stats.get_move_speed() * 0.5; // Half speed for patrol
                enemy.facing_direction = "right";
                
                // Check for edge or patrol point boundary
                var has_floor_ahead = position_meeting(
                    enemy.owner.x + enemy.edge_check_dist, 
                    enemy.owner.y + enemy.owner.sprite_height + 2, 
                    obj_floor
                );
                
                if (!has_floor_ahead || enemy.owner.x >= enemy.patrol_point_right) {
                    enemy.moving_right = false;
                    enemy.facing_direction = "left";
                }
            } else {
                enemy.xsp = -enemy.stats.get_move_speed() * 0.5; // Half speed for patrol
                enemy.facing_direction = "left";
                
                // Check for edge or patrol point boundary
                var has_floor_ahead = position_meeting(
                    enemy.owner.x - enemy.edge_check_dist, 
                    enemy.owner.y + enemy.owner.sprite_height + 2, 
                    obj_floor
                );
                
                if (!has_floor_ahead || enemy.owner.x <= enemy.patrol_point_left) {
                    enemy.moving_right = true;
                    enemy.facing_direction = "right";
                }
            }
            
            // Check for player/NPC in detection range
            var player = instance_nearest(enemy.owner.x, enemy.owner.y, obj_player_creature_parent);
            var npc = instance_nearest(enemy.owner.x, enemy.owner.y, obj_npc_parent);
            
            var detected_target = noone;
            var closest_dist = enemy.detection_range;
            
            // Check player distance
            if (player != noone) {
                var player_dist = point_distance(enemy.owner.x, enemy.owner.y, player.x, player.y);
                if (player_dist < closest_dist) {
                    closest_dist = player_dist;
                    detected_target = player;
                }
            }
            
            // Check NPC distance
            if (npc != noone) {
                var npc_dist = point_distance(enemy.owner.x, enemy.owner.y, npc.x, npc.y);
                if (npc_dist < closest_dist) {
                    closest_dist = npc_dist;
                    detected_target = npc;
                }
            }
            
            // If target detected, transition to chase
            if (detected_target != noone) {
                enemy.closest_target = detected_target;
                enemy.closest_distance = closest_dist;
                enemy.state_machine.change_state("CHASE");
            }
        }
    );
    
    // CHASE state
    enemy.state_machine.add_state("CHASE", 
        function() {
            // On enter chase
            enemy.is_patrolling = false;
        },
        function() {
            // Update chase behavior
            if (enemy.closest_target == noone) {
                // Return to patrol if no target
                enemy.state_machine.change_state("PATROL");
                return;
            }
            
            // Update distance to target
            enemy.closest_distance = point_distance(
                enemy.owner.x, enemy.owner.y, 
                enemy.closest_target.x, enemy.closest_target.y
            );
            
            // Check if target is still in range
            if (enemy.closest_distance > enemy.detection_range) {
                enemy.closest_target = noone;
                enemy.state_machine.change_state("PATROL");
                return;
            }
            
            // Update facing direction
            enemy.facing_direction = (enemy.closest_target.x > enemy.owner.x) ? "right" : "left";
            
            // Check for melee attack range
            if (enemy.closest_distance < enemy.owner.sprite_width + 10) {
                enemy.state_machine.change_state("MELEE_ATTACK");
                return;
            }
            
            // Check for ranged attack if enemy can shoot
            if (variable_struct_exists(enemy, "can_shoot_ghostball") && 
                enemy.can_shoot_ghostball && 
                enemy.ghostball_cooldown <= 0 &&
                enemy.closest_distance < enemy.detection_range * 0.8) {
                enemy.state_machine.change_state("RANGED_ATTACK");
                return;
            }
            
            // Move toward target
            var move_dir = (enemy.closest_target.x > enemy.owner.x) ? 1 : -1;
            
            // Check for floor ahead before moving
            var check_x = enemy.owner.x + (move_dir * enemy.edge_check_dist);
            var has_floor_ahead = position_meeting(
                check_x, 
                enemy.owner.y + enemy.owner.sprite_height + 2, 
                obj_floor
            );
            
            if (has_floor_ahead) {
                enemy.xsp = move_dir * enemy.stats.get_move_speed();
            } else {
                // Stop at ledge
                enemy.xsp = 0;
            }
        }
    );
    
    // MELEE_ATTACK state
    enemy.state_machine.add_state("MELEE_ATTACK", 
        function() {
            // On enter melee attack
            enemy.is_melee_attacking = true;
            enemy.xsp = 0; // Stop movement during attack
            enemy.melee_cooldown = enemy.melee_cooldown_max;
            
            // Create melee hitbox if this enemy has one
            if (variable_struct_exists(enemy, "melee_hitbox_obj")) {
                var hitbox_offset = (enemy.facing_direction == "right") ? 20 : -20;
                var hitbox = instance_create_layer(
                    enemy.owner.x + hitbox_offset,
                    enemy.owner.y - 16,
                    "Instances",
                    enemy.melee_hitbox_obj
                );
                
                if (hitbox != noone) {
                    hitbox.creator = enemy.owner;
                    hitbox.damage = enemy.melee_damage;
                    hitbox.life_time = 15;
                }
            }
        },
        function() {
            // Update melee attack
            // Most implementation happens in animation events
            // Just need to check when to end the state
            
            enemy.melee_cooldown--;
            
            // Transition back to chase after cooldown period
            if (enemy.melee_cooldown <= 0) {
                enemy.is_melee_attacking = false;
                enemy.state_machine.change_state("CHASE");
            }
        }
    );
    
    // RANGED_ATTACK state
    enemy.state_machine.add_state("RANGED_ATTACK", 
        function() {
            // On enter ranged attack
            enemy.is_shooting = true;
            enemy.xsp = 0; // Stop movement during attack
            
            // Shoot in direction of target
            if (enemy.closest_target != noone) {
                var dir = point_direction(
                    enemy.owner.x, enemy.owner.y,
                    enemy.closest_target.x, enemy.closest_target.y
                );
                
                // Use the weapon system to fire
                with(obj_weapon_system) {
                    if (variable_struct_exists(other.enemy, "can_shoot_ghostball") && other.enemy.can_shoot_ghostball) {
                        shoot_ghostball(other.owner, dir);
                    } else if (variable_struct_exists(other.enemy, "has_shotgun") && other.enemy.has_shotgun) {
                        shoot_shotgun(other.owner, dir);
                    }
                }
            }
        },
        function() {
            // Just wait to transition back - animation controlled
            enemy.state_machine.change_state("CHASE");
        }
    );
    
    // HIT state - when enemy gets hit
    enemy.state_machine.add_state("HIT", 
        function() {
            // On enter hit state
            enemy.xsp = 0;
            enemy.hit_timer = enemy.hit_timer_max;
        },
        function() {
            // Decrement timer and transition back when done
            enemy.hit_timer--;
            
            if (enemy.hit_timer <= 0) {
                // Go back to chase if player still in range
                if (enemy.closest_target != noone && 
                    enemy.closest_distance <= enemy.detection_range) {
                    enemy.state_machine.change_state("CHASE");
                } else {
                    enemy.state_machine.change_state("PATROL");
                }
            }
        }
    );
    
    // DEAD state
    enemy.state_machine.add_state("DEAD", 
        function() {
            // On enter dead state
            enemy.xsp = 0;
            enemy.ysp = 0;
            
            // Give currency to player
            var player = instance_find(obj_player_creature_parent, 0);
            if (player != noone) {
                player.creature.currency += enemy.currency_value;
            }
            
            // Create death effect
            // (This would be done by specific enemy types)
        },
        function() {
            // Just wait to be destroyed - animation controlled
        }
    );
}