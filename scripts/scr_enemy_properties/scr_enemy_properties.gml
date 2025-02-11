// scr_enemy_properties
function create_enemy_properties() {
    var props = create_creature_properties();
    
    // Add enemy-specific properties
    props.respawn_on_death = false;  // Enemies typically don't respawn
    props.is_hostile = true;         // Flag for enemy behavior
    props.detection_range = 200;     // Example enemy-specific property
    props.aggro_range = 150;        // Example enemy-specific property
	
	// Currency properties
    props.currency_value = 10;  // Base currency value
	
	//Health System
	props.max_health = 100;           // Enemies are weaker
    props.current_health = 100;
	
    return props;
}