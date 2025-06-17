// obj_Orchyde Create Event (parent = obj_enemy_parent)
event_inherited();
creature = create_orchyde_properties();

// 1. Add Health Component
add_component(entity, "health", create_health_component(400));
entity.health.max_health = 400;
entity.health.current_health = 400;

// 2. Add Weapon Component (Now holds both melee and ranged potential)
var weapon_comp = create_weapon_component(entity);
var weapon_data = { base_cooldown: 120, pickup_obj_index: undefined }; // Cooldown for shotgun
weapon_comp.pickup_weapon("shotgun", weapon_data);
add_component(entity, "weapon", weapon_comp);

// 3. Add Movement Component
// The movement component will read from an "input" struct, just like the player.
// The AI component will write to this struct.
creature.input = { left: false, right: false, jump: false, fire: false }; // Give it a blank input struct
add_component(entity, "movement", create_movement_component(entity, creature.stats));

// 4. Add the NEW AI Component
var ai_config = {
    detection_range: 250,
    lose_target_range: 500,
    melee_range: 56,
    patrol_speed_mult: 0.5,
    attack_anim_time: 20,
    melee_cooldown_max: 90 // <--- ADD THIS LINE
};
add_component(entity, "ai", create_ai_component(entity, ai_config));
// --- END NEW SETUP ---

// The hit function can be simplified or handled by a future "status" component
hit = function() {
    if (hit_timer <= 0) {
        hit_timer = hit_timer_max;
        sprite_index = sOrchydeHit;
        image_index = 0;
    }
}