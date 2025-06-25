// The system's NEW Step Event
with (obj_creature_parent)
{
    // Skip this instance if it's not fully initialized
    if (!variable_instance_exists(id, "entity") || !entity.has_component("health")) {
        continue;
    }

    // --- HANDLE PLAYER CONTACT DAMAGE ---
    // The system is still useful for handling interactions between different objects.
    if (is_player) {
        if (!variable_instance_exists(id, "damage_cooldown")) {
            damage_cooldown = 0;
        }
        if (damage_cooldown > 0) {
            damage_cooldown--;
        }

        if (damage_cooldown <= 0) {
            var collided_enemy = instance_place(x, y, obj_enemy_parent);
            if (collided_enemy != noone) {
                entity.health.take_damage(10); 
                damage_cooldown = 30;

                var kb_dir = point_direction(collided_enemy.x, collided_enemy.y, x, y);
                var knock_h = lengthdir_x(3, kb_dir);
                var knock_v = min(-2, lengthdir_y(3, kb_dir));
                entity.movement.apply_knockback(knock_h, knock_v);
            }
        }
    }
}