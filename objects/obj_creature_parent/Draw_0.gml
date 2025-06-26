// This is the final, correct code for obj_creature_parent's Draw Event.

// This direct check is more robust and avoids the issues with the has_component() helper.
if (variable_instance_exists(id, "entity") && 
    variable_struct_exists(entity, "components") && 
    variable_struct_exists(entity.components, "health")) {
        
    // If all those things exist, draw the health bar.
    entity.health.draw_health_bar();
}