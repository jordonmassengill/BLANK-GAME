// obj_ghoststrike Create Event (parent = obj_player_projectile_parent)
event_inherited();  // Get parent object's create event

projectile.initialize({
    speed: 5,
    lifetime: 40,
    damage: 40,
    damage_type: DAMAGE_TYPE.MAGICAL,
    element_type: ELEMENT_TYPE.GHOST
});