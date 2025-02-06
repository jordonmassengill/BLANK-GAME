// scr_stats_system

function create_stats() {
    return {
        // Base stats
        max_health: 100,
        current_health: 100,
        armor: 1,                  // Damage reduction percentage (0-100)
        physical_damage: 1.0,      // Base physical damage multiplier
        magical_damage: 1.0,         // Base magic damage multiplier
        elemental_power: 1.0,      // Base elemental effects multiplier
        move_speed: 3,             // Base movement speed
        health_regen: 0,           // Health gained per second
        rate_of_fire: 1.0,         // Base rate of fire multiplier
        proj_speed: 1.0,           // Base projectile speed multiplier
        life_steal: 0.0,           // Life steal percentage
        resistance: 1,           // NEW: Resistance to elemental effects (0-100%)
        
        // Modifiers/Bonuses
		max_health_bonus: 0,
		life_steal_bonus: 0,
		health_regen_bonus: 0,
		physical_damage_bonus: 0,
		magical_damage_bonus: 0,
		elemental_power_bonus: 0,
		speed_bonus: 0,
        rof_bonus: 0,
        proj_speed_bonus: 0,
        armor_bonus: 0,
		resistance_bonus: 0,
        
        // Methods for getting final stat values
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
            return physical_damage + physical_damage_bonus;
        },
        
        get_magical_damage: function() {
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
        }
    };
}