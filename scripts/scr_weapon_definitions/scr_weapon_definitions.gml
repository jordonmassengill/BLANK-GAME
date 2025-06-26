/// @function get_weapon_definitions()
/// @description Returns a struct containing definitions for all weapons in the game.
function get_weapon_definitions() {
    return {
        //======================================================================
        // PLAYER WEAPONS (Using original spawn distances)
        //======================================================================
        fireball: {
            projectile_object: obj_fireball,
            base_cooldown: 15,
            fire_pattern: "single",
            spawn_radius: 24,
			bubble_v_offset: 0,
        },
        bomb: {
            projectile_object: obj_bomb,
            base_cooldown: 120,
            fire_pattern: "arc",
            spawn_radius: 24,
			bubble_v_offset: -1,
        },
        dart: {
            projectile_object: obj_dart,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_radius: 24,
			bubble_v_offset: -1,
        },
        waterball: {
            projectile_object: obj_waterball,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_radius: 16,
			bubble_v_offset: -5,
        },
        iceball: {
            projectile_object: obj_iceball,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_radius: 24,
			bubble_v_offset: -1,
        },
        electro: {
            projectile_object: obj_electro,
            base_cooldown: 20,
            fire_pattern: "single",
            spawn_radius: 24,
			bubble_v_offset: -3,
        },
        ghoststrike: {
            projectile_object: obj_ghoststrike,
            base_cooldown: 10,
            fire_pattern: "single",
            spawn_radius: 24,
			bubble_v_offset: -1,
        },

        //======================================================================
        // ENEMY WEAPONS (These had their own special offsets)
        //======================================================================
        ghostball: {
            projectile_object: obj_ghostball,
            base_cooldown: 180,
            fire_pattern: "single",
            spawn_radius: 24,
			bubble_v_offset: -1,
        },
        shotgun: {
            projectile_object: obj_shotgun_pellet,
            base_cooldown: 120,
            fire_pattern: "spread",
            pellet_count: 5,
            spread_angle: 30,
            spawn_radius: 15,
			bubble_v_offset: -1,
        },
        orchyde_melee: {
            projectile_object: obj_Orchyde_melee_hitbox,
            base_cooldown: 90,
            fire_pattern: "melee",
            hitbox_damage: 10,
            hitbox_lifetime: 15,
            hitbox_offset: 28,
        }
    };
}