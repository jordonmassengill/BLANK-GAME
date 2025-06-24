// obj_player_projectile_parent Collision Event with obj_enemy_parent
if (variable_instance_exists(other, "entity") && 
    variable_struct_exists(other.entity, "health")) {
    projectile.on_hit(other);
}
instance_destroy();
