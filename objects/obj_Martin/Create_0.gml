// obj_Martin Create Event (parent = obj_npc_parent) - FINAL VERSION

// This function defines Martin's unique patrol behavior.
function martin_patrol_update() {
    var inst = self.owner.owner_instance;

    // Check if we've reached a patrol point
    if (inst.x >= self.patrol_point_right) {
        self.patrol_dir = -1; // Turn left
    } else if (inst.x <= self.patrol_point_left) {
        self.patrol_dir = 1; // Turn right
    }

    // --- THIS IS THE KEY CHANGE ---
    // 1. Tell the movement component what speed multiplier to use.
    self.owner.movement.set_speed_multiplier(self.config.patrol_speed_mult);
    
    // 2. Tell the movement component which direction to go.
    self.owner.movement.set_input_xy(self.patrol_dir, 0);
}


// --- Main Create Event Logic ---
event_inherited();

creature = create_creature_properties();
creature.facing_direction = "right"; // <-- ADD THIS LINE
entity = {};
entity.owner_instance = id;
add_component(entity, "health", create_health_component(1000));
creature.input = { left: false, right: false, jump: false, fire: false };
add_component(entity, "movement", create_movement_component(entity, creature.stats));

// Create the AI component as before
var ai_config = {
    detection_range: 0,
    lose_target_range: 0,   // <-- Add this
    melee_range: 0,           // <-- Add this
    patrol_speed_mult: 0.4,
    attack_anim_time: 0,      // <-- Add this
    melee_cooldown_max: 0,     // <-- Add this
	body_width_left: 16,
    body_width_right: 16
};
add_component(entity, "ai", create_ai_component(entity, ai_config));

// --- NEW: Add custom data and override the AI state ---
entity.ai.patrol_point_left = x - 100;
entity.ai.patrol_point_right = x + 100;

// This is the magic part: We're replacing the default PATROL logic
// with our own custom function for this instance only.
entity.ai.state_machine.add_state(
    "PATROL",                           // State to modify
    undefined,                          // Keep the default "On Enter" logic
    method(entity.ai, martin_patrol_update) // Use our new custom "On Update" logic
);
// --- End of new logic ---


// Set Martin's specific stats
entity.health.max_health = 1000;
entity.health.current_health = 1000;
creature.stats.armor = 0;
creature.stats.resistance = 5;
creature.stats.move_speed = 1.0;

// Sprite properties
image_xscale = (entity.ai.patrol_dir == 1) ? 1 : -1;

// Create shop inventory (unchanged)
shop = create_shop_inventory();
shop_add_item(shop, "Jetpack", 120, obj_jpack, "Allows double jumping and hovering");
shop_add_item(shop, "Power Orb", 50, obj_Powerupgrade, "Upgrades damage-related stats");
shop_add_item(shop, "Speed Orb", 50, obj_Speedupgrade, "Upgrades movement and attack speed");
shop_add_item(shop, "Defense Orb", 50, obj_Defenseupgrade, "Upgrades defensive stats");


// Create shop menu (unchanged)
shop_menu = create_shop_menu();

// Add hit function (unchanged)
hit = function(damage_amount = 0) {
    if (damage_amount > 0 && variable_struct_exists(entity, "health")) {
        entity.health.take_damage(damage_amount);
    }
    return true;
};