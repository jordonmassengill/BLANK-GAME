// scr_specific_enemy_properties

function create_ghost_properties() {
    var props = create_enemy_properties();
    
    // Override ghost-specific properties
    props.max_health = 200;
    props.current_health = 200;
    props.detection_range = 250;    // Ghosts can detect from further away
    props.aggro_range = 200;        // Ghosts have larger aggro range
	props.currency_value = 46;
    
    // Add shooting properties
    props.can_shoot_ghostball = true;
    props.ghostball_cooldown = 0;
    props.ghostball_cooldown_max = 300;  // 5 seconds (60 steps per second)
    
    return props;
}

function create_dummy_properties() {
    var props = create_enemy_properties();
    
    // Override dummy-specific properties
    props.max_health = 800;
    props.current_health = 700;
    props.detection_range = 150;    // Zombies detect from shorter range
    props.aggro_range = 100;        // Zombies have smaller aggro range
	props.stats.health_regen = 20;
	props.stats.armor = 10;
	props.stats.resistance = 4;
    
    return props;
}

function create_orchyde_properties() {
    var props = create_enemy_properties();
    
    // Override properties
    props.max_health = 400;
    props.current_health = 400;
    props.detection_range = 200;
    props.aggro_range = 150;
    props.stats.armor = 10;
    props.stats.resistance = 4;
	props.stats.move_speed = 2;
	props.currency_value = 181;
    
    // Shotgun properties
    props.has_shotgun = true;
    props.can_shoot_shotgun = true;
    props.shotgun_cooldown = 0;
    props.shotgun_cooldown_max = 120;  // Debug this value
    
    return props;
}

// Add more enemy-specific property functions as needed