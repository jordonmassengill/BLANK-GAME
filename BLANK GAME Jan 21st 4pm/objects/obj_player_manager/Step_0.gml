// Step Event of obj_player_manager
with(obj_player_creature_parent) {
    // Camera following for main player
    if (variable_instance_exists(id, "is_main_player") && is_main_player) {
        var camera = view_camera[0];
        var cam_width = camera_get_view_width(camera);
        var cam_height = camera_get_view_height(camera);
        
        // Add vertical offset (60% from top instead of 50%)
        var vertical_offset = cam_height * 0.1;  // This moves view up by 10% of screen height
        
        var cam_x = clamp(x - cam_width / 2, 0, room_width - cam_width);
        var cam_y = clamp(y - (cam_height * 0.75), 0, room_height - cam_height);  // Changed from 0.5 to 0.6
        
        camera_set_view_pos(camera, cam_x, cam_y);
    }
    
    // Level progression
    if (creature.can_progress_level && place_meeting(x, y, obj_flag)) {
        room_goto_next();
    }

    
    // Here we could add:
    // - Player respawn management
    // - Score tracking
    // - Checkpoint system
    // - Multiple player management
    // - Player-specific game rules
    // - etc.
}