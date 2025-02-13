// obj_bomb Create Event (parent = obj_player_projectile_parent)
event_inherited();

projectile.initialize({
    speed: 6,
    lifetime: 60,
    damage: 1,           // Direct hit does 1 physical damage
    damage_type: DAMAGE_TYPE.PHYSICAL,
    element_type: ELEMENT_TYPE.NONE
});

// Add falling arc effect
vspeed = -4;  // Initial upward velocity
gravity = 0.2; // Gravity effect
has_exploded = false;  // Flag to prevent multiple explosions

// Create explosion function defined in Create event
create_explosion = function() {
    if (has_exploded) return;  // Don't create multiple explosions
    
    show_debug_message("Creating explosion!");
    var explosion = instance_create_layer(x, y, "Instances", obj_explosion);
    explosion.creator = projectile.shooter;
    explosion.sprite_index = sExplode;
    explosion.image_speed = 1;
    has_exploded = true;  // Set flag before destroying
    instance_destroy();
}