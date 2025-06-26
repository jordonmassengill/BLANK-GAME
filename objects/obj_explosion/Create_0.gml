// obj_explosion Create Event (parent = obj_projectile_parent)
creator = noone;
damage_type = DAMAGE_TYPE.AOE;
element_type = ELEMENT_TYPE.FIRE;
base_damage = 50;
base_radius = 32;
aoe_radius = base_radius;  // Initialize with base radius
has_dealt_damage = false;
image_speed = 1;

projectile.initialize({
    speed: 0,
    lifetime: 1,
    damage: base_damage,
    damage_type: damage_type,
    element_type: element_type,
    base_radius: base_radius
});

projectile.shooter = creator;


creator_changed = function() {
    projectile.shooter = creator;  // Update projectile.shooter whenever creator changes
}