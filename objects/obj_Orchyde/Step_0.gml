// This is the final, clean version of obj_Orchyde's Step Event

event_inherited(); // Handles parent logic like status effects

// Update all components. The magic happens inside them!
entity.ai.update();       // The AI decides what to do...
entity.movement.update(); // ...the movement component does it.
entity.weapon.update();   // ...and the weapon component tracks cooldowns.

// The rest of your Step Event code...
if (hit_timer > 0) {
    hit_timer--;
}

if (entity.movement.xsp > 0) creature.facing_direction = "right";
if (entity.movement.xsp < 0) creature.facing_direction = "left";

creature.xsp = entity.movement.xsp;
creature.ysp = entity.movement.ysp;