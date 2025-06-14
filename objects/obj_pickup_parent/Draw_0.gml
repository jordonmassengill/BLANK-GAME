// Draw the object's actual sprite first
draw_self();

// Now, draw its collision mask on top with 50% transparency
// so we can see its "physical body"
if (mask_index != -1) {
    draw_sprite_ext(mask_index, 0, x, y, 1, 1, 0, c_white, 0.5);
}