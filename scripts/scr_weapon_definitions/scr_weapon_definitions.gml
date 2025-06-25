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
            spawn_offset_h: 12, // CORRECTED: Original value
            spawn_offset_v: 0,  // CORRECTED: Original value
        },
        bomb: {
            projectile_object: obj_bomb,
            base_cooldown: 120,
            fire_pattern: "arc",
            spawn_offset_h: 12, // CORRECTED: Original value
            spawn_offset_v: 0,  // CORRECTED: Original value
        },
        dart: {
            projectile_object: obj_dart,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_offset_h: 12, // CORRECTED: Original value
            spawn_offset_v: 0,  // CORRECTED: Original value
        },
        waterball: {
            projectile_object: obj_waterball,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_offset_h: 12, // CORRECTED: Original value
            spawn_offset_v: 0,  // CORRECTED: Original value
        },
        iceball: {
            projectile_object: obj_iceball,
            base_cooldown: 100,
            fire_pattern: "single",
            spawn_offset_h: 12, // CORRECTED: Original value
            spawn_offset_v: 0,  // CORRECTED: Original value
        },
        electro: {
            projectile_object: obj_electro,
            base_cooldown: 20,
            fire_pattern: "single",
            spawn_offset_h: 12, // CORRECTED: Original value
            spawn_offset_v: 0,  // CORRECTED: Original value
        },
        ghoststrike: {
            projectile_object: obj_ghoststrike,
            base_cooldown: 10,
            fire_pattern: "single",
            spawn_offset_h: 12, // CORRECTED: Original value
            spawn_offset_v: 0,  // CORRECTED: Original value
        },

        //======================================================================
        // ENEMY WEAPONS (These had their own special offsets)
        //======================================================================
        ghostball: {
            projectile_object: obj_ghostball,
            base_cooldown: 180,
            fire_pattern: "single",
            spawn_offset_h: 12,  // CORRECTED: Matching standard horizontal distance
            spawn_offset_v: -16, // This was the original vertical_offset
        },
        shotgun: {
            projectile_object: obj_shotgun_pellet,
            base_cooldown: 120,
            fire_pattern: "spread",
            pellet_count: 5,
            spread_angle: 30,
            spawn_offset_h: 12,  // CORRECTED: Matching standard horizontal distance
            spawn_offset_v: 0,   // CORRECTED: Shotgun also had no vertical offset
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