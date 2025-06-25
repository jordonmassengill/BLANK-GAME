// scr_enemy_properties.gml
// Defines the default, non-behavioral properties for all enemies.
// AI and movement logic is now handled by components.

function create_enemy_properties() {
	var props = create_creature_properties();
	
	// Flags to identify this creature type
	props.is_hostile = true;
	props.is_enemy = true;

	// Default currency value for a generic enemy.
	// This can be overridden in specific enemy files (e.g., in create_orchyde_properties).
	props.currency_value = CURRENCY_VALUE_DEFAULT;
	
	return props;
}