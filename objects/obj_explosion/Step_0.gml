// obj_explosion Step Event
if (!has_dealt_damage) {
    var result = apply_aoe_damage(x, y, projectile.shooter, base_radius, base_damage, element_type);
    aoe_radius = result.radius;  // Store the calculated radius
    has_dealt_damage = true;
}

// Destroy when animation ends
if (image_index >= image_number - 1) {
    instance_destroy();
}