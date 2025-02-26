// obj_Orchyde Step Event
event_inherited();
// Handle hit timer
if (hit_timer > 0) {
    hit_timer--;
    if (hit_timer <= 0) {
        sprite_index = sOrchydeIdle;
        is_melee_attacking = false;
        is_shooting = false;
    }
}

var nearest_player = instance_nearest(x, y, obj_player_creature_parent);
var player_in_range = false;

if (nearest_player != noone) {
    var distance_to_player = point_distance(x, y, nearest_player.x, nearest_player.y);
    
    if (distance_to_player <= creature.detection_range) {
        player_in_range = true;
        is_patrolling = false;
        
        // Update facing direction
        image_xscale = (nearest_player.x > x) ? 1 : -1;
        creature.facing_direction = (image_xscale > 0) ? "right" : "left";
        
        creature.input.left = false;
        creature.input.right = false;

        if (!is_melee_attacking && !is_shooting) {
            if (distance_to_player > melee_range) {
                if (creature.shotgun_cooldown <= 0) {
                    var direction_to_player = point_direction(x, y, nearest_player.x, nearest_player.y);
                    with(obj_weapon_system) {
                        var shot_fired = shoot_shotgun(other, direction_to_player);
                        if (shot_fired) {
                            other.is_shooting = true;
                            other.sprite_index = sOrchydeShoot;
                            other.image_index = 0;
                        }
                    }
                } else {
                    var move_right = nearest_player.x > x;
                    var has_floor_ahead = position_meeting(
                        x + (move_right ? edge_check_dist : -edge_check_dist), 
                        y + sprite_height + 2, 
                        obj_floor
                    );
                    
                    if (has_floor_ahead) {
                        // Set direction flags
                        creature.input.right = move_right;
                        creature.input.left = !move_right;
                        
                        // IMPORTANT: Apply movement using stats speed
                        var actual_speed = creature.stats.get_move_speed();
                        if (move_right) {
                            x += actual_speed;
                        } else {
                            x -= actual_speed;
                        }
                    }
                }
            } else if (melee_cooldown <= 0) {
                is_melee_attacking = true;
                sprite_index = sOrchydeMelee;
                image_index = 0;
                melee_cooldown = melee_cooldown_max;
                
                var hitbox = instance_create_layer(
                    x + (image_xscale * 20),
                    y - 16,
                    "instances",
                    obj_Orchyde_melee_hitbox
                );
                hitbox.creator = id;
                hitbox.damage = melee_damage;
                hitbox.life_time = 15;
            }
        }
    }
}
    
// Handle patrol
if (!player_in_range && !is_shooting && !is_melee_attacking) {
    is_patrolling = true;
    
    if (moving_right) {
        image_xscale = 1;
        creature.facing_direction = "right";
        var has_floor_ahead = position_meeting(x + edge_check_dist, y + sprite_height + 2, obj_floor);
        
        if (!has_floor_ahead || x >= patrol_point_right) {
            moving_right = false;
            image_xscale = -1;
            creature.facing_direction = "left";
        } else {
            creature.input.right = true;
            creature.input.left = false;
            
            // IMPORTANT: Apply patrol movement using stats speed (at half speed)
            var patrol_speed = creature.stats.get_move_speed() * 0.5;
            x += patrol_speed;
        }
    } else {
        image_xscale = -1;
        creature.facing_direction = "left";
        var has_floor_ahead = position_meeting(x - edge_check_dist, y + sprite_height + 2, obj_floor);
        
        if (!has_floor_ahead || x <= patrol_point_left) {
            moving_right = true;
            image_xscale = 1;
            creature.facing_direction = "right";
        } else {
            creature.input.right = false;
            creature.input.left = true;
            
            // IMPORTANT: Apply patrol movement using stats speed (at half speed)
            var patrol_speed = creature.stats.get_move_speed() * 0.5;
            x -= patrol_speed;
        }
    }
}

// Handle cooldowns
if (melee_cooldown > 0) melee_cooldown--;

// Update animation based on state
if (hit_timer > 0) {
    sprite_index = sOrchydeHit;
} else if (is_melee_attacking) {
    sprite_index = sOrchydeMelee;
} else if (is_shooting) {
    sprite_index = sOrchydeShoot;
} else if (creature.input.left || creature.input.right) {
    sprite_index = sOrchydeRun;
} else {
    sprite_index = sOrchydeIdle;
}