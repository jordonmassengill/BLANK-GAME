// obj_guy Create Event (parent = obj_player_creature_parent)
event_inherited();

// Create creature properties for non-health related functionality
creature = create_player_properties();
is_main_player = true;

// Set up entity with components
entity = {};
entity.owner_instance = id;

// --- COMPONENT SETUP ---
// Add Health Component (with death callback)
var health_comp = create_health_component(150);
health_comp.regen_rate = creature.stats.health_regen;
var death_function = method(id, function() {
	var death_effect = instance_create_layer(x, y, "Instances", obj_HeroDeath);
	death_effect.sprite_index = sHeroDeath;
	death_effect.image_xscale = sprite_direction;
	instance_create_layer(0, 0, "Instances", obj_death_screen);
	creature.status_manager.clear_effects();
	instance_destroy();
});
health_comp.set_death_callback(death_function);
add_component(entity, "health", health_comp);

// Add NEW Movement Component
add_component(entity, "movement", create_movement_component(entity, creature.stats));
// --- END COMPONENT SETUP ---


// Animation variables
sprite_direction = 1; // 1 for right, -1 for left
image_speed = 1;

// Hit animation variables
hit_timer = 0;
hit_timer_max = 15;

// Updated hit function
hit = function(damage_amount = 0) {
	if (hit_timer <= 0) {
		hit_timer = hit_timer_max;
		
		// Briefly stop movement when hit (handled by anim_state now)
		
		// Apply damage using the health component
		if (damage_amount > 0 && variable_struct_exists(entity, "health")) {
			entity.health.take_damage(damage_amount);
		}
	}
	return true;
}
