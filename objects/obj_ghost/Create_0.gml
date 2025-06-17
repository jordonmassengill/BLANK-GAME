// obj_ghost Create Event (parent = obj_enemy_parent) - REFACTORED
event_inherited();
creature = create_ghost_properties();

// --- Component Setup ---
entity = {};
entity.owner_instance = id;

// Health Component
add_component(entity, "health", create_health_component(200));
entity.health.max_health = 200;
entity.health.current_health = 200;

// Weapon Component (already had this, but we ensure it's clean)
var weapon_comp = create_weapon_component(entity);
var weapon_data = { base_cooldown: 180, pickup_obj_index: undefined }; // 3 second cooldown
weapon_comp.pickup_weapon("ghostball", weapon_data);
add_component(entity, "weapon", weapon_comp);

// Movement Component (even stationary objects need this for gravity and consistency)
creature.input = { left: false, right: false, jump: false, fire: false };
add_component(entity, "movement", create_movement_component(entity, creature.stats));

// AI Component (with a custom, simple state machine)
var ai_config = {
    detection_range: 250,
    lose_target_range: 400,
    attack_anim_time: 30,
    melee_range: 0,           // <-- ADD THIS
    patrol_speed_mult: 0,     // <-- ADD THIS
    melee_cooldown_max: 0     // <-- ADD THIS
};
add_component(entity, "ai", create_ai_component(entity, ai_config));
// --- End Component Setup ---


// --- Custom AI States for the Ghost ---
var sm = entity.ai.state_machine;

// STATE 1: IDLE - just looks for a target
sm.add_state("IDLE",
    undefined, // No "On Enter" logic needed
    method(entity.ai, function() {
        self._find_target();
        if (self.target != noone) {
            self.state_machine.change_state("ATTACK"); // <-- CHANGE THIS LINE
        }
    })
);

// STATE 2: ATTACK - fires if it can, then returns to IDLE
sm.add_state("ATTACK",
    method(entity.ai, function() {
        self.attack_timer = self.config.attack_anim_time;
    }),
    method(entity.ai, function() {
        // Check if we should lose the target
        if (self.target == noone || !instance_exists(self.target) || point_distance(self.owner.owner_instance.x, 0, self.target.x, 0) > self.config.lose_target_range) {
            self.target = noone;
            self.state_machine.change_state("IDLE"); // <-- CHANGE THIS LINE
            return;
        }

        // Aim and fire if cooldown is ready
        self.owner.weapon.fire(self.target);

        // Wait for animation/cooldown time, then go back to looking
        self.attack_timer--;
        if (self.attack_timer <= 0) {
            self.state_machine.change_state("IDLE"); // <-- AND CHANGE THIS LINE
        }
    })
);

// Set the initial state for the ghost's AI
sm.change_state("IDLE");
