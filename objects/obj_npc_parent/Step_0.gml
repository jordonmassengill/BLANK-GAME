// obj_npc_parent Step Event (parent = obj_creature_parent)
event_inherited();

// Death check - use component health system
var is_dead = false;

// Check component health
if (variable_instance_exists(id, "entity") && 
    variable_struct_exists(entity, "health") && 
    entity.health.current_health <= 0) {
    is_dead = true;
}

// If dead, destroy the instance
if (is_dead) {
    // Reset any active status effects
    // The 'creature' struct is now guaranteed to exist, so this is safe.
    if (variable_struct_exists(creature, "status_manager")) {
        creature.status_manager.clear_effects();
    }
    instance_destroy();
    exit;
}