// obj_dummy Create Event (parent = obj_enemy_parent) - MIGRATED
event_inherited();
creature = create_dummy_properties();

// Add health component (this is already correct)
add_component(entity, "health", create_health_component(800));
entity.health.max_health = 800;
entity.health.current_health = 700;

// Add movement component (even non-moving objects need this for consistency)
creature.input = { left: false, right: false, jump: false, fire: false };
add_component(entity, "movement", create_movement_component(entity, creature.stats));

// --- NEW: Add the AI Component ---
// We configure it to do nothing. It won't detect or move.
var ai_config = {
    detection_range: 0,
    lose_target_range: 0,
    melee_range: 0,
    patrol_speed_mult: 0,
    attack_anim_time: 0,
    melee_cooldown_max: 0
};
add_component(entity, "ai", create_ai_component(entity, ai_config));

// --- NEW: Override the AI states to do nothing ---
// This tells the dummy's AI to just stay in an IDLE state forever.
var sm = entity.ai.state_machine;
sm.add_state("IDLE", undefined, function() { /* Do nothing */ });
sm.change_state("IDLE");