// In scr_stats_system
function create_stats() {
    return {
        // Base stats
        max_health: 100,
        current_health: 100,
        armor: 1,                  // Damage reduction percentage (0-100)
        physical_damage: 1,        // Physical damage level (starts at 1)
        magical_damage: 1,         // Magic damage level (starts at 1)
        elemental_power: 1.0,      // Base elemental effects multiplier
        move_speed: 3,             // Base movement speed
        health_regen: 0,           // Health gained per second
        rate_of_fire: 1.0,         // Base rate of fire multiplier
        proj_speed: 1.0,           // Base projectile speed multiplier
        life_steal: 0.0,           // Life steal percentage
        resistance: 1,             // Resistance to elemental effects (0-100%)
        aoe_damage: 1.0,		   // Base AoE damage multiplier
        aoe_radius: 32,			   // Base explosion radius in pixels
        
        // Modifiers/Bonuses
        max_health_bonus: 0,
        life_steal_bonus: 0,
        health_regen_bonus: 0,
        physical_damage_bonus: 0,  // Added to level before bonus calculation
        magical_damage_bonus: 0,   // Added to level before bonus calculation
        elemental_power_bonus: 0,
        speed_bonus: 0,
        rof_bonus: 0,
        proj_speed_bonus: 0,
        armor_bonus: 0,
        resistance_bonus: 0,
        aoe_damage_bonus: 0,
        
        // Crit properties
        crit_level: 1,              // Level 1 means no crits
        crit_timer: 0,              // Current timer progress
        crit_ready: false,          // Whether a crit is queued up
        base_crit_cooldown: 600,    // Base cooldown (10 seconds at 60 fps)
        
        // Getter methods
        get_max_health: function() {
            return max_health + max_health_bonus;
        },
        
        get_life_steal: function() {
            return life_steal + life_steal_bonus;
        },
        
        get_health_regen: function() {
            return health_regen + health_regen_bonus;
        },
        
        get_armor: function() {
            return armor + armor_bonus;
        },
        
        get_physical_damage: function() {
            // Returns the current physical damage level
            return physical_damage + physical_damage_bonus;
        },
        
        get_magical_damage: function() {
            // Returns the current magical damage level
            return magical_damage + magical_damage_bonus;
        },
        
        get_elemental_power: function() {
            return elemental_power + elemental_power_bonus;
        },
        
        get_move_speed: function() {
            return move_speed + speed_bonus;
        },
        
        get_rate_of_fire: function() {
            return rate_of_fire + rof_bonus;
        },
        
        get_proj_speed: function() {
            return proj_speed + proj_speed_bonus;
        },
        
        get_resistance: function() {
            return resistance + resistance_bonus;
        },
        
        get_aoe_damage: function() {
            return aoe_damage + aoe_damage_bonus;
        },
        
        get_explosion_radius: function() {
            // Each level adds 8 pixels to radius
            var level = get_aoe_damage();
            return aoe_radius + ((level - 1) * 8);
        },
        
        get_current_crit_cooldown: function() {
            var effective_level = min(crit_level, 10);
            if (effective_level > 1) {
                return base_crit_cooldown - ((effective_level - 1) * 60);
            }
            return base_crit_cooldown;
        },
        
        get_crit_multiplier: function() {
            if (crit_level <= 1) return 1.0;
            return 1 + ((crit_level - 1) * 0.25);
        },
        
        update_crit_timer: function() {
            if (crit_level > 1 && !crit_ready) {
                crit_timer++;
                var current_cooldown = get_current_crit_cooldown();
                if (crit_timer >= current_cooldown) {
                    crit_ready = true;
                    crit_timer = current_cooldown;
                }
            }
        },
        
        consume_crit: function() {
            if (crit_ready) {
                crit_ready = false;
                crit_timer = 0;
                return true;
            }
            return false;
        }
    };
}