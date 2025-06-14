// Draw Event for obj_background_manger
var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);
var view_width = camera_get_view_width(view_camera[0]);
var view_height = camera_get_view_height(view_camera[0]);

// Draw each background layer
for(var i = 0; i < array_length(backgrounds); i++) {
    var bg = backgrounds[i];
    
    // Calculate parallax position
    var bg_x = cam_x * bg.scroll_speed;
    
    // Calculate how many times we need to repeat to fill the view
    var repeats = ceil(view_width / view_width) + 2;  // +2 for safety
    
    // Draw multiple copies to ensure coverage
    for(var j = -repeats; j <= repeats; j++) {
        draw_sprite_stretched(bg.sprite, 0, 
            bg_x + (j * view_width), cam_y, 
            view_width, view_height);
    }
}