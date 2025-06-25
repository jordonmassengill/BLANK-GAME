// obj_guy Step Event (parent = obj_player_creature_parent)
// First, check if any major menu that pauses the game is active.
var a_menu_is_open = (instance_exists(obj_stats_menu) && obj_stats_menu.stats_menu_active) ||
                     (instance_exists(obj_exchange_menu) && obj_exchange_menu.menu_active) ||
                     (instance_exists(obj_pause_controller) && obj_pause_controller.game_paused);

// If a menu is open, we MUST NOT update the movement and weapon components.
// This prevents gravity from accumulating while the floor is deactivated.
if (a_menu_is_open) {
    // We exit the script early. The player instance remains active so the menu can
    // read its stats/inventory, but it doesn't run its own physics or logic.
    exit;
}


event_inherited(); // Handles status effects
if (!instance_exists(id)) {
    exit;
}

// 1. Update all core components
entity.health.update();
entity.movement.update(); // This now handles all state changes, physics, and jump cooldowns
entity.weapon.update();   // This updates weapon cooldowns

// 2. Handle non-component logic
// Update hit timer
if (hit_timer > 0) {
	hit_timer--;
}

// Update facing direction based on input
if (creature.input.left) sprite_direction = -1;
if (creature.input.right) sprite_direction = 1;

// Test damage - press T to apply damage directly to component
if (keyboard_check_pressed(ord("T"))) {
	entity.health.take_damage(10);
}

// Handle Weapon Switching Input ---
if (creature.input.swap_weapon_pressed) {
    entity.weapon.swap_active_weapon();
}

// Pass the final speeds from the component to the creature struct
// This is so obj_movement_system can apply them.
creature.xsp = entity.movement.xsp;
creature.ysp = entity.movement.ysp;