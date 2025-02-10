// In scr_player_properties

function create_player_properties() {
    var props = create_creature_properties();
    
    // Add player-specific properties
    props.can_progress_level = true;
    props.respawn_on_death = true;
    props.input.using_controller = gamepad_is_connected(0);
    
    // Health System
    props.max_health = 150;
    props.current_health = 150;
	
	props.stats.crit_level = 2;  // Start with level 2 crit
    
    // Add inventory
    props.inventory = create_inventory();  // Start with 10 slots
    props.die = function() {
        room_restart();
    }
    
    return props;
}