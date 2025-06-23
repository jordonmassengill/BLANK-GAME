// Check if the target instance has finished its Create Event and is ready.
if (variable_instance_exists(other, "is_ready") && other.is_ready == true) {

    // If it's ready, then we can safely run our normal logic.
    if (variable_instance_exists(other, "entity") &&
        variable_struct_exists(other.entity, "health")) {
        projectile.on_hit(other);
    }
}

// Always destroy the projectile to prevent it from passing through an "unready" enemy.
instance_destroy();