// This is the new Step Event for obj_creature_parent
show_debug_message("Step Event for: " + object_get_name(object_index));

// First, a safety check to ensure the instance wasn't destroyed by another process (like DOT damage)
if (!instance_exists(id)) {
    exit;
}

// Check if this creature has been upgraded to use the new component system
if (variable_instance_exists(id, "entity") && entity.has_component("status")) {
    // If it has the component, just tell it to update itself.
    // All the logic for applying effects is now handled inside the component.
	    show_debug_message("--> Status component update is being called.");

    entity.status.update();
}