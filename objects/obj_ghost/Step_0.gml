// obj_ghost Step Event
event_inherited();
entity.weapon.update(); // --- ADD THIS LINE AT THE TOP ---

// If ghost has a valid target within range
if (closest_target != noone && closest_distance <= creature.detection_range) {
    // Calculate direction to target for shooting
    var direction_to_target = point_direction(x, y, closest_target.x, closest_target.y);
    
    // Replace the old check with a direct call to the component's fire method
    // The component itself will check the cooldown.
    entity.weapon.fire("primary");
    is_shooting = true;
    sprite_index = sGhost;
    image_index = 0;
}

// Reset shooting state after cooldown is back
if (creature.ghostball_cooldown <= 0) {
    is_shooting = false;
}