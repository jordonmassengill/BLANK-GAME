// obj_bomb Collision Event with obj_enemy_parent
if (!has_exploded && !is_exploding) {
    projectile.on_hit(other);
    create_explosion();
}