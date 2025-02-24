// obj_explosion Draw Event
draw_self();

// Draw radius circle for visualization
if (global.debug_visible) {
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    draw_circle(x, y, aoe_radius, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}