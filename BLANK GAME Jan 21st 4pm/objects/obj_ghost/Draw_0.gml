// Draw Event for obj_ghost
draw_self();

// Draw health bar
if (variable_instance_exists(id, "entity") && 
    variable_struct_exists(entity, "health")) {
    entity.health.draw_health_bar();
}
