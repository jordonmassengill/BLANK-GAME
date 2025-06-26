// obj_ghost Draw Event - REFACTORED
event_inherited(); 

var _new_sprite = sGhost; // Default to idle sprite

// Determine the correct sprite based on the AI's current state
if (variable_instance_exists(id, "entity")) { // Safety check
    // Since there's no sGhostShoot sprite, we use sGhost for both states.
    // If you create a shooting sprite later, you can add its name here.
    if (entity.ai.state_machine.is_in_state("ATTACK")) {
        _new_sprite = sGhost; // Use the default sprite
    } else {
        _new_sprite = sGhost; // Use the default sprite
    }
}

// Only change the sprite_index if the new sprite is different
if (sprite_index != _new_sprite) {
    sprite_index = _new_sprite;
    image_index = 0; // Reset the animation
}

// Set facing direction
image_xscale = (creature.facing_direction == "right" ? 1 : -1);

// Draw the object and its health bar
draw_self();