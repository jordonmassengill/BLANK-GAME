// obj_guy Create Event (parent = obj_player_creature_parent)
event_inherited();

// Create creature properties for non-health related functionality
creature = create_player_properties();
is_main_player = true;

// Set up entity with enhanced health component
entity = {};
entity.owner_instance = id;

// Create health component with a death callback
var health_comp = create_health_component(150); // Default player health
health_comp.regen_rate = creature.stats.health_regen;  // Sync regeneration rate

// Create death callback separately with variable binding
death_function = method(id, function() {
    // Create death effect
    var death_effect = instance_create_layer(x, y, "Instances", obj_HeroDeath);
    death_effect.sprite_index = sHeroDeath;
    death_effect.image_xscale = sprite_direction;
    
    // Create death screen
    instance_create_layer(0, 0, "Instances", obj_death_screen);
    
    // Clear effects and destroy
    creature.status_manager.clear_effects();
    instance_destroy();
});

// Set the method as the death callback
health_comp.set_death_callback(death_function);

add_component(entity, "health", health_comp);

// Animation variables
anim_state = "idle";
sprite_direction = 1;  // 1 for right, -1 for left
anim_blend = 0;  // 0 = idle, 1 = full running
image_speed = 1;
is_grounded = true;

// New falling animation variables
fall_start = true;
fall_frame_timer = 0;
jetpack_active = false;
fall_animation_started = false; 

// Add hit animation variables
hit_timer = 0;
hit_timer_max = 15;

// Updated hit function that uses only the health component
hit = function(damage_amount = 0) {
    if (hit_timer <= 0) {
        hit_timer = hit_timer_max;
        sprite_index = sHeroHit;
        image_index = 0;
        image_speed = 1;
        
        // Briefly stop movement when hit
        creature.input.left = false;
        creature.input.right = false;
        
        // Apply damage using the health component
        if (damage_amount > 0 && variable_struct_exists(entity, "health")) {
            entity.health.take_damage(damage_amount);
        }
    }
    return true;
}