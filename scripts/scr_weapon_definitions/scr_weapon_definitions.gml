/// @function get_weapon_definitions()
/// @description Returns a struct containing definitions for all weapons in the game.
function get_weapon_definitions() {
    return {
        //======================================================================
        // PLAYER WEAPONS
        //======================================================================
        fireball: {
            projectile_object: obj_fireball,
            base_cooldown: 15,
            fire_pattern: "single",
            spawn_offset_h: 16, // NEW: Horizontal distance from origin
            spawn_offset_v: -20, // NEW: Vertical distance from origin (negative is up)
        },
        bomb: {
            projectile_object: obj_bomb,
            base_cooldown: 120,
            fire_pattern: "arc",
            spawn_offset_h: 16, // NEW
            spawn_offset_v: -8,  // NEW: A smaller vertical offset so it looks like it's thrown
        },
        dart: {
            projectile_object: obj_dart,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_offset_h: 16, // NEW
            spawn_offset_v: -20, // NEW
        },
        waterball: {
            projectile_object: obj_waterball,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_offset_h: 16, // NEW
            spawn_offset_v: -20, // NEW
        },
        iceball: {
            projectile_object: obj_iceball,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_offset_h: 16, // NEW
            spawn_offset_v: -20, // NEW
        },
        electro: {
            projectile_object: obj_electro,
            base_cooldown: 20,
            fire_pattern: "single",
            spawn_offset_h: 16, // NEW
            spawn_offset_v: -20, // NEW
        },
        ghoststrike: {
            projectile_object: obj_ghoststrike,
            base_cooldown: 10,
            fire_pattern: "single",
            spawn_offset_h: 16, // NEW
            spawn_offset_v: -20, // NEW
        },

        //======================================================================
        // ENEMY WEAPONS
        //======================================================================
        ghostball: {
            projectile_object: obj_ghostball,
            base_cooldown: 180,
            fire_pattern: "single",
            spawn_offset_h: 16,  // NEW
            spawn_offset_v: -16, // This was the old vertical_offset
        },
        shotgun: {
            projectile_object: obj_shotgun_pellet,
            base_cooldown: 120,
            fire_pattern: "spread",
            pellet_count: 5,
            spread_angle: 30,
            spawn_offset_h: 20, // NEW: A bit further for a shotgun
            spawn_offset_v: -18, // NEW
        },
        orchyde_melee: {
            projectile_object: obj_Orchyde_melee_hitbox,
            base_cooldown: 90,
            fire_pattern: "melee",
            hitbox_damage: 10,
            hitbox_lifetime: 15,
            hitbox_offset: 28, // Using a slightly larger offset for the melee attack
        }
    };
}