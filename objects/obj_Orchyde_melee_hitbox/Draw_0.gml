// Draw Event (for debugging) for obj_Orchyde_melee_hitbox
if (global.debug_visible) {
    draw_set_alpha(0.5);
    draw_set_color(c_red);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1);
}