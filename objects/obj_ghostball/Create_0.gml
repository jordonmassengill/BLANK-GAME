// obj_ghostball Create Event (parent = obj_enemt_projectile_parent)
event_inherited();  // Get parent object's create event

projectile.initialize({
    speed: 6,
    lifetime: 120,
    damage: 35,
    damage_type: DAMAGE_TYPE.PHYSICAL,
    element_type: ELEMENT_TYPE.GHOST
});