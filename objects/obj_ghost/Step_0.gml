// obj_ghost Step Event - REFACTORED
event_inherited(); // Handles parent logic like status effects

// Update all components. The magic happens inside them!
entity.ai.update();
entity.movement.update();
entity.weapon.update();

// Update facing direction based on the AI's target
if (entity.ai.target != noone) {
    creature.facing_direction = (entity.ai.target.x > x) ? "right" : "left";
}

// The movement component handles gravity, but we ensure speed is otherwise zero
creature.xsp = entity.movement.xsp;
creature.ysp = entity.movement.ysp;