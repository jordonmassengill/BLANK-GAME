// obj_player_projectile_parent Create Event (parent = obj_projectile_parent)
event_inherited();  // Get parent object's create event
projectile.can_hit_player = false;  // Player projectiles can hit anything EXCEPT players