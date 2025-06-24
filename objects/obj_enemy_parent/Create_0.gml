// obj_enemy_parent Create Event (parent = obj_creature_parent)
event_inherited();  // Get creature stuff
is_enemy = true;

entity = {};
entity.owner_instance = id;

// Initialize entity for component-based health system

// These will be overridden by specific enemy types
hit_timer = 0;
hit_timer_max = 15;
is_melee_attacking = false;
is_shooting = false;
closest_target = noone;  // Add these two variables 
closest_distance = 0;    // so child objects can access them
distance_to_player = 0;  // Add this new instance variable

// Initialize the hit function
hit = function(damage_amount = 0) {
    if (hit_timer <= 0) {
        hit_timer = hit_timer_max;
        
        // Any other hit reactions should go here
        // For example, changing sprite, playing sound, etc.
    }
    return true;
};
