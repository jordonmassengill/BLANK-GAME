// obj_pause_controller Step Event
with(obj_player_creature_parent) {
    if (creature.input.pause_pressed) {
        other.game_paused = !other.game_paused;
        
        if (other.game_paused) {
            instance_deactivate_all(true);
            instance_activate_object(obj_pause_controller);
            instance_activate_object(obj_input_manager);
        } else {
            instance_activate_all();
        }
    }
    
    if (other.game_paused) {
        // Menu navigation
        if (creature.input.menu_up) {
            other.selected_item = max(0, other.selected_item - 1);
        }
        if (creature.input.menu_down) {
            other.selected_item = min(array_length(other.menu_items) - 1, other.selected_item + 1);
        }
        
        // Menu selection
        if (creature.input.menu_select) {
            switch(other.selected_item) {
                case 0: // Resume
                    other.game_paused = false;
                    instance_activate_all();
					
					with (obj_player_creature_parent) {
            if (entity.has_component("movement")) {
                entity.movement.force_state_re_evaluation();
            }
        }
                    break;
                case 1: // Restart
                    other.game_paused = false;
                    instance_activate_all();
                    room_restart();
                    break;
                case 2: // Quit
                    game_end();
                    break;
            }
        }
    }
}