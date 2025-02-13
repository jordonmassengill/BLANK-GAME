// obj_explosion Draw Event
draw_self();

// Debug visualization
if (global.debug_visible && creator) {
    var explosion_radius = creator.creature.stats.get_explosion_radius();
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    draw_circle(x, y, explosion_radius, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}