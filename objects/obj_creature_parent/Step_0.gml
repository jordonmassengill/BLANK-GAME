// This is the new Step Event for obj_creature_parent

// First, a safety check to ensure the instance wasn't destroyed by another process (like DOT damage)
if (!instance_exists(id)) {
    exit;
}

// Update the status component for this creature
if (variable_instance_exists(id, "entity") && entity.has_component("status")) {
    entity.status.update();
}