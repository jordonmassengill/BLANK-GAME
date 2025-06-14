// obj_guy Step Event (parent = obj_player_creature_parent)
event_inherited(); // Handles status effects

// 1. Update all core components
entity.health.update();
entity.movement.update(); // This now handles all state changes, physics, and jump cooldowns

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

// Pass the final speeds from the component to the creature struct
// This is so obj_movement_system can apply them.
creature.xsp = entity.movement.xsp;
creature.ysp = entity.movement.ysp;
