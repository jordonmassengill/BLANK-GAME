// obj_bomb Create Event (parent = obj_player_projectile_parent)
event_inherited();

projectile.initialize({
    speed: 4,
    lifetime: 60,
    damage: 1,           // Direct hit does 1 physical damage
    damage_type: DAMAGE_TYPE.PHYSICAL,
    element_type: ELEMENT_TYPE.NONE
});

// Add falling arc effect
vspeed = -3.3;  // Initial upward velocity
gravity = 0.08; // Gravity effect
has_exploded = false;  // Flag to prevent multiple explosions
is_exploding = false;  // Flag to prevent multiple explosion triggers
alarm[0] = -1;  // Alarm for delayed explosion

// Create explosion function defined in Create event
create_explosion = function() {
    if (has_exploded || is_exploding) return;  // Don't create multiple explosions
    
    is_exploding = true;  // Set flag immediately to prevent multiple calls
    alarm[0] = 1;  // Schedule explosion for next frame
}