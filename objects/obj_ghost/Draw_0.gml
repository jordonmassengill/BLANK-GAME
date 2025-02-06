// Draw Event for obj_ghost
draw_self();
if (variable_instance_exists(id, "creature")) {
    global.health_system.draw_health_bar(id);
}