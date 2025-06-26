// This is the final version for obj_creature_parent's Draw Event.

if (variable_instance_exists(id, "entity") && 
    variable_struct_exists(entity, "components") && 
    variable_struct_exists(entity.components, "health")) {
        
    // If all those things exist, draw the health bar.
    entity.health.draw_health_bar();
}