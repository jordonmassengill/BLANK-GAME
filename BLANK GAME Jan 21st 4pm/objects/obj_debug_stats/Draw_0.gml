// Draw Event of obj_debug_stats
if (!visible) exit;

var camera = view_camera[0];
var view_x = camera_get_view_x(camera);
var view_y = camera_get_view_y(camera);
var view_w = camera_get_view_width(camera);
var view_h = camera_get_view_height(camera);

// Find player and draw their stats centered where the red square was
with(obj_guy) {
    draw_debug_stats(id);  // Pass the instance ID instead of the creature struct
}