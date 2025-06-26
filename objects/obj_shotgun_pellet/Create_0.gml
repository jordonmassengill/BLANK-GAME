// obj_shotgun_pellet Create Event (parent = obj_enemy_projectile_parent)
event_inherited();  // Get parent object's create event
projectile.can_hit_player = true;

projectile.initialize({
    speed: 8,
    lifetime: 30,
    damage: 5,
    damage_type: DAMAGE_TYPE.PHYSICAL,
    element_type: ELEMENT_TYPE.NONE
});