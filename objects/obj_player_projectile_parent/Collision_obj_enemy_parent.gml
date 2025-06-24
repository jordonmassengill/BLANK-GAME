// Check if the target instance has finished its Create Event and is ready.
if (variable_instance_exists(other, "is_ready") && other.is_ready == true) {

    // This is the gatekeeper: ONLY call on_hit if the target has ALL required components.
    if (variable_instance_exists(other, "entity") && other.entity.has_component("health") && other.entity.has_component("status")) {
        projectile.on_hit(other);
    }
}

// Always destroy the projectile after a collision.
instance_destroy();