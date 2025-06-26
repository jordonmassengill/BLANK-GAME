// Draw Event of obj_Orchyde
event_inherited(); 

// Set facing direction based on the creature's properties
image_xscale = (creature.facing_direction == "right" ? 1 : -1);

// This variable will hold the sprite we WANT to be showing
var _new_sprite = sprite_index;

// Determine the correct sprite based on the AI's current state
if (hit_timer > 0) {
	_new_sprite = sOrchydeHit;
} else if (entity.ai.state_machine.is_in_state("MELEE_ATTACK")) {
	_new_sprite = sOrchydeMelee;
} else if (entity.ai.state_machine.is_in_state("RANGED_ATTACK")) {
	_new_sprite = sOrchydeShoot;
} else {
	// FINAL, SIMPLIFIED LOGIC FOR IDLE/RUN
	// This covers both CHASE and PATROL.
	// In either state, if the enemy is actually moving, show the run animation.
	// If it's not moving (e.g., stopped at a ledge), show the idle animation.
	if (abs(creature.xsp) > 0) {
		_new_sprite = sOrchydeRun;
	} else {
		_new_sprite = sOrchydeIdle;
	}
}

// Only change the sprite_index if the new sprite is different from the current one.
// This prevents the animation from resetting every frame.
if (sprite_index != _new_sprite) {
	sprite_index = _new_sprite;
	image_index = 0; // Reset the animation to the beginning when changing sprites
}

// Draw the object with its new sprite
draw_self();