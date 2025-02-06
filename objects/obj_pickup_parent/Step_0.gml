// obj_pickup_parent Step Event
var collider = instance_place(x, y, obj_player_creature_parent);
if (collider != noone) {
    apply_effect(collider);  // Each child implements this differently
    instance_destroy();
}