// obj_ghost Step Event
event_inherited();

// If ghost has a valid target within range
if (closest_target != noone && closest_distance <= creature.detection_range) {
    // Calculate direction to target for shooting
    var direction_to_target = point_direction(x, y, closest_target.x, closest_target.y);
    
    // Try to shoot if cooldown is ready
    if (creature.ghostball_cooldown <= 0) {  // Removed the is_shooting check here
        with(obj_weapon_system) {
            var shot_fired = shoot_ghostball(other, direction_to_target);
            if (shot_fired) {
                other.is_shooting = true;
                other.sprite_index = sGhost;  // Change this to shooting sprite if you have one
                other.image_index = 0;
            }
        }
    }
}

// Reset shooting state after cooldown is back
if (creature.ghostball_cooldown <= 0) {
    is_shooting = false;
}