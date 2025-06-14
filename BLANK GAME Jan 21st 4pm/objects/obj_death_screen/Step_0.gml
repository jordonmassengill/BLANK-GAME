// obj_DeathScreen Step Event
current_delay++;

// Only start fading after delay
if (current_delay >= start_delay) {
    started_fading = true;
    fade_alpha = min(fade_alpha + fade_speed, 1);
}

// Handle text fade
if (fade_alpha >= 1 && current_delay >= (start_delay + text_delay)) {
    text_alpha = min(text_alpha + fade_speed, 1);
}