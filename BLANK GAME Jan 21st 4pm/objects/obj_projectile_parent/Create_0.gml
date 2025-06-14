// obj_projectile_parent Create Event
projectile = create_base_projectile();

// Add this shared function that uses the instance's base_radius
function handle_aoe_damage() {
    if (projectile.damage_type == DAMAGE_TYPE.AOE) {
        if (!variable_instance_exists(id, "base_radius")) {
            show_debug_message("Warning: AOE object missing base_radius property");
            return false;
        }
        var result = apply_aoe_damage(x, y, projectile.shooter, base_radius, projectile.damage, projectile.element_type);
        return true;
    }
    return false;
}