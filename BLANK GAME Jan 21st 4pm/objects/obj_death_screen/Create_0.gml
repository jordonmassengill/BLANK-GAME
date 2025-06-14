// obj_DeathScreen Create Event
fade_alpha = 0;        // Controls grayscale fade
text_alpha = 0;        // Controls text fade
fade_speed = 0.02;     // How fast the screen fades
start_delay = 120;     // 2 seconds (60 frames/second * 2)
current_delay = 0;     // Current delay counter
text_delay = 60;       // Additional delay before text appears
started_fading = false;

// Create surface for the effect
surface = -1;