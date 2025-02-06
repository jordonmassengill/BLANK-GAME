//Create Event for obj_movement_system
enum PlayerState {
    NORMAL,
    JUMP_SQUAT,
    JUMPING,
	KNOCKBACK
}

#macro MOVE_SPEED 3
#macro GRAVITY 0.1
#macro MAX_FALL_SPEED 4
#macro JUMP_FORCE -3
#macro JUMP_RELEASE_MULTIPLIER 0.5
#macro JUMP_SQUAT_FRAMES 5
#macro MIN_JUMP_FRAMES 3
#macro JETPACK_FORCE -0.3
#macro JETPACK_MAX_SPEED -3.5
#macro JETPACK_FUEL 2000