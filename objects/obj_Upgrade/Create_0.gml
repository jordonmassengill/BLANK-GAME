// obj_upgrade_platform Create Event (parent = obj_floor)

// Menu control variables
is_player_on_platform = false;
has_opened_menu = false;

// Visual effect variables
pulse = 0;
pulse_speed = 0.05;
pulse_min = 0.8;
pulse_max = 1.2;
pulse_direction = 1;
detection_range = 100;  // How far away to start showing feedback
glow_alpha = 0;
glow_color = make_color_rgb(0, 255, 255);  // Cyan color for the glow