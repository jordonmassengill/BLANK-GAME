// The speed at which we fall and sink
var fall_speed = 1;

// Check for the floor ONE pixel below our current position
var on_floor = place_meeting(x, y + 1, obj_floor);

// If we are NOT on the floor, move down.
if (!on_floor)
{
    y += fall_speed;
}

// --- Visual Debugging ---
// If we are on the floor, turn green.
// If we are in the air, turn red.
if (on_floor)
{
    image_blend = c_lime;
}
else
{
    image_blend = c_red;
}