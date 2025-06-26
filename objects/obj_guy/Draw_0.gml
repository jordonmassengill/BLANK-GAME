// obj_guy Draw Event
event_inherited(); 

// Apply direction flip
image_xscale = sprite_direction;

// Get the current animation state from the movement component
var anim_state = entity.movement.get_anim_state();

// Update sprite based on state
switch(anim_state) {
	case "idle":    sprite_index = sHeroIdle; break;
	case "running": sprite_index = sHeroRun; break;
	case "jumping": sprite_index = sHeroJump; break;
	case "jetpack": sprite_index = sHeroJetpack; break;
	case "falling": sprite_index = sHeroFall; break;
	case "hit":     sprite_index = sHeroHit; break;
}

// Draw the sprite
draw_self();