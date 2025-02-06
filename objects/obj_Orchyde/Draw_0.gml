// Draw Event of obj_Orchyde
var original_xscale = image_xscale;
image_xscale = (creature.facing_direction == "right" ? 1 : -1) * abs(image_xscale);

// Update animation state based on current state
if (hit_timer > 0) {
    sprite_index = sOrchydeHit;
    image_speed = 1;
} else if (is_melee_attacking) {
    sprite_index = sOrchydeMelee;
    image_speed = 1;
} else if (is_shooting) {
    sprite_index = sOrchydeShoot;
    image_speed = 1;
} else if ((creature.input.left || creature.input.right) && !is_melee_attacking && !is_shooting) {
    sprite_index = sOrchydeRun;
    image_speed = 1;
} else {
    sprite_index = sOrchydeIdle;
    image_speed = 1;
}

draw_self();

if (variable_instance_exists(id, "creature")) {
    global.health_system.draw_health_bar(id);
}

image_xscale = original_xscale;

// Debug visuals
if (global.debug_visible) {
    draw_set_color(c_yellow);
    draw_circle(x, y, melee_range, true);  // Show melee range
    draw_set_color(c_red);
    draw_circle(x, y, creature.detection_range, true);  // Show detection range
    draw_set_color(c_white);
}