// obj_enemy_parent Step Event
event_inherited();

// Find nearest player and NPC
var nearest_player = instance_nearest(x, y, obj_player_creature_parent);
var nearest_npc = instance_nearest(x, y, obj_npc_parent);

closest_target = noone;  // Use the instance variables instead
closest_distance = creature.detection_range;

// Check player distance
if (nearest_player != noone) {
    var player_distance = point_distance(x, y, nearest_player.x, nearest_player.y);
    if (player_distance < closest_distance) {
        closest_distance = player_distance;
        closest_target = nearest_player;
    }
}

// Check NPC distance
if (nearest_npc != noone) {
    var npc_distance = point_distance(x, y, nearest_npc.x, nearest_npc.y);
    if (npc_distance < closest_distance) {
        closest_distance = npc_distance;
        closest_target = nearest_npc;
    }
}

// Hit timer logic - Only reset shooting state when actually hit
if (hit_timer > 0) {
    hit_timer--; // Decrement the hit timer
    if (hit_timer <= 0) {
        is_melee_attacking = false;  // Reset attack state
    }
}

// Update facing direction if we have a target
if (closest_target != noone && closest_distance <= creature.detection_range) {
    var direction_to_target = point_direction(x, y, closest_target.x, closest_target.y);
    // Update facing direction
    creature.facing_direction = (direction_to_target < 90 || direction_to_target > 270) ? "right" : "left";
}

// Death check
if (creature.current_health <= 0) {
    var player = instance_find(obj_player_creature_parent, 0);
    if (player != noone) {
        player.creature.currency += creature.currency_value;
    }
    
    // Call enemy-specific death event
    event_user(0);
    exit;
}