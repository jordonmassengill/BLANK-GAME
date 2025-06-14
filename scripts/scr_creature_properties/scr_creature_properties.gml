// scr_creature_properties.gml
// This script defines the base properties for all creatures.
// Player-specific movement and state machine logic has been moved 
// to the scr_movement_component for a cleaner, more modular design.

function create_creature_properties() {
	var props = {
		// --- Core Systems ---
		stats: create_stats(),
		status_manager: create_status_manager(),
		input: {
			left: false,
			right: false,
			jump: false,
			fire: false,
			alt_fire: false,
			aim_x: 0,
			aim_y: 0,
			target_x: 0,
			target_y: 0,
			using_controller: false,
			pause_pressed: false,
			stats_menu_pressed: false,
			menu_up: false,
			menu_down: false,
			menu_select: false,
			menu_back: false,
			interact: false,
			swap_weapon_pressed: false,

		},
		
		// --- Ability Properties ---
		has_jetpack: false,
		jetpack_fuel: 0,
		
		has_fireball: false,
		can_shoot_fireball: false,
		fireball_cooldown: 0,
		
		has_bomb: false,
		can_throw_bomb: false,
		bomb_cooldown: 0,
		
		has_dart: false,
		can_shoot_dart: false,
		dart_cooldown: 0,
		
		has_waterball: false,
		can_shoot_waterball: false,
		waterball_cooldown: 0,
		
		has_iceball: false,
		can_shoot_iceball: false,
		iceball_cooldown: 0,
		
		has_electro: false,
		can_shoot_electro: false,
		electro_cooldown: 0,
		
		has_ghoststrike: false,
		can_shoot_ghoststrike: false,
		ghoststrike_cooldown: 0,
		
		// --- Game Logic Properties ---
		can_die: true,
		
		// This flag is still needed so the movement component knows
		// when the player has released the jump button, allowing a new jump.
		jump_released: true,
	};
	
	// NOTE: State machine and movement variables (xsp, ysp, facing_direction)
	// are no longer initialized here for the player. They are handled by components.
	// Enemies will have these properties added back in their own property scripts
	// until they are also converted to the component system.
	
	return props;
}
