// obj_bomb Collision Event with obj_enemy_parent
show_debug_message("Bomb collided with enemy!");

// Apply direct damage (1 physical damage)
projectile.on_hit(other);

// Create explosion (50 AoE damage)
create_explosion();