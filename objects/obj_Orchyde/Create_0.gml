// obj_Orchyde Create Event (parent = obj_enemy_parent)
event_inherited();
creature = create_orchyde_properties();

// 1. Add Health Component and initialize its values
add_component(entity, "health", create_health_component(400));
entity.health.max_health = 400;
entity.health.current_health = 400;

// 2. Define the death callback function
var death_function = method(id, function() {
    var player = instance_find(obj_player_creature_parent, 0);
    if (player != noone) {
        player.creature.currency += creature.currency_value;
    }
    instance_destroy(); 
});

// 3. Set the callback on the now-existing health component
entity.health.set_death_callback(death_function);

// 4. Add Weapon Component
var weapon_comp = create_weapon_component(entity);
var weapon_data = { base_cooldown: 120, pickup_obj_index: undefined }; // Cooldown for shotgun
weapon_comp.pickup_weapon("shotgun", weapon_data);
add_component(entity, "weapon", weapon_comp);

// 5. Add Movement Component
creature.input = { left: false, right: false, jump: false, fire: false };
add_component(entity, "movement", create_movement_component(entity, creature.stats));

// 6. Add the AI Component
var ai_config = {
    detection_range: 200,
    lose_target_range: 250,
    melee_range: 45,
    patrol_speed_mult: 0.5,
    attack_anim_time: 20,
    melee_cooldown_max: 90,
	body_width_left: 28,  // Approximate pixels from origin to logical left edge
    body_width_right: 28,
};
add_component(entity, "ai", create_ai_component(entity, ai_config));

// 7. Define the hit function (for visual feedback)
hit = function() {
    if (hit_timer <= 0) {
        hit_timer = hit_timer_max;
        sprite_index = sOrchydeHit;
        image_index = 0;
    }
}