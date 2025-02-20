// obj_explosion Step Event
// Deal damage on the first frame
if (!has_dealt_damage) {
    deal_damage();
}

// Destroy when animation ends
if (image_index >= image_number - 1) {
    instance_destroy();
}