// obj_creature_parent Create Event
if (!variable_instance_exists(id, "projectile_detector")) {
    projectile_detector = instance_create_layer(x, y, layer, obj_projectile_detector);
    projectile_detector.owner = id;
}