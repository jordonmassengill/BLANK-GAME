// obj_ghost Step Event
event_inherited();

// Find nearest player
var nearest_player = instance_nearest(x, y, obj_player_creature_parent);
if (nearest_player != noone) {
    var distance_to_player = point_distance(x, y, nearest_player.x, nearest_player.y);
    
    // Check if player is in range
    if (distance_to_player <= creature.detection_range) {
        
        // Calculate direction to player
        var direction_to_player = point_direction(x, y, nearest_player.x, nearest_player.y);

        // Try to shoot ghostball using weapon system
        with(obj_weapon_system) {
            shoot_ghostball(other, direction_to_player);
        }
    }
}