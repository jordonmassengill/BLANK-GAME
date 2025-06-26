// obj_Orchyde Step Event
event_inherited(); // Handles parent logic, which can include death from DOT

// --- THIS IS THE DEFINITIVE FIX ---
// The event_inherited() call above can trigger this instance's death.
// We MUST check if the instance still exists before proceeding with its own logic.
if (!instance_exists(id)) {
    exit; // Stop this script immediately if the instance was destroyed.
}

// Update all components. The magic happens inside them!
entity.ai.update();       // The AI decides what to do...
entity.movement.update(); // ...the movement component does it.
entity.weapon.update();   // ...and the weapon component tracks cooldowns.

// The rest of your Step Event code...
if (hit_timer > 0) {
    hit_timer--;
}

creature.xsp = entity.movement.xsp;
creature.ysp = entity.movement.ysp;