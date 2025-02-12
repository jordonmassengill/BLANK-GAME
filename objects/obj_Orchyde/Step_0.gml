// obj_Orchyde Step Event
event_inherited();

// Handle hit timer
if (hit_timer > 0) {
    hit_timer--; // Decrement the hit timer
    if (hit_timer <= 0) {
        // Exit hit state
        sprite_index = sOrchydeIdle; // Reset to idle sprite
        is_melee_attacking = false;  // Reset attack state
        is_shooting = false;         // Reset shooting state
    }
}

var nearest_player = instance_nearest(x, y, obj_player_creature_parent);
var player_in_range = false;

if (nearest_player != noone) {
    var distance_to_player = point_distance(x, y, nearest_player.x, nearest_player.y);
    
    // Check if player is in range
    if (distance_to_player <= creature.detection_range) {
        player_in_range = true;
        is_patrolling = false;
        
        // Calculate direction to player
        var direction_to_player = point_direction(x, y, nearest_player.x, nearest_player.y);
        
        // Update facing direction
        creature.facing_direction = (direction_to_player < 90 || direction_to_player > 270) ? "right" : "left";
        
        // Reset movement input
        creature.input.left = false;
        creature.input.right = false;

        // Only move if not attacking
        if (!is_melee_attacking && !is_shooting) {
            if (distance_to_player > melee_range) {
                // Move towards player if not in melee range
                if (nearest_player.x > x) {
                    creature.input.right = true;
                } else {
                    creature.input.left = true;
                }
            }
        }
        
        // Combat behavior
        if (distance_to_player <= melee_range) {
            if (melee_cooldown <= 0 && !is_melee_attacking && !is_shooting && hit_timer <= hit_timer_max / 2) {
                // Start melee attack
                is_melee_attacking = true;
                sprite_index = sOrchydeMelee;
                image_index = 0;
                melee_cooldown = melee_cooldown_max;
                
                var hitbox = instance_create_layer(
                    x + (creature.facing_direction == "right" ? 20 : -20),
                    y - 16,
                    "instances",
                    obj_Orchyde_melee_hitbox
                );
                hitbox.creator = id;
                hitbox.damage = melee_damage;
                hitbox.life_time = 15;
            }
        } else if (!is_melee_attacking && !is_shooting && creature.shotgun_cooldown <= 0 && hit_timer <= hit_timer_max / 2) {
            with(obj_weapon_system) {
                var shot_fired = shoot_shotgun(other, direction_to_player);
                if (shot_fired) {
                    other.is_shooting = true;
                    other.sprite_index = sOrchydeShoot;
                    other.image_index = 0;
                }
            }
        }
    }
}

// Handle cooldowns
if (melee_cooldown > 0) {
    melee_cooldown--;
}

// Handle patrol if not shooting and not in range
if (!player_in_range && !is_shooting && !is_melee_attacking) {
    is_patrolling = true;
    
    if (moving_right) {
        creature.input.right = true;
        creature.input.left = false;
        creature.facing_direction = "right";
        if (x >= patrol_point_right) {
            moving_right = false;
        }
    } else {
        creature.input.left = true;
        creature.input.right = false;
        creature.facing_direction = "left";
        if (x <= patrol_point_left) {
            moving_right = true;
        }
    }
}