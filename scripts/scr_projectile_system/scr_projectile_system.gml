// In scr_projectile_system
function create_base_projectile() {
    return {
        // Existing properties
        base_speed: 0,
        base_lifetime: 0,
        base_damage: 0,
        speed: 0,
        lifetime: 0,
        damage: 0,
        damage_type: DAMAGE_TYPE.PHYSICAL,
        element_type: ELEMENT_TYPE.NONE,
        shooter: noone,
        projectile_props: undefined,
        can_hit_player: false,
        
        // New crit property
        is_crit: false,

        // Existing initialize method remains unchanged...
        initialize: function(config) {
            self.base_speed = variable_struct_exists(config, "speed") ? config[$ "speed"] : self.base_speed;
            self.base_lifetime = variable_struct_exists(config, "lifetime") ? config[$ "lifetime"] : self.base_lifetime;
            self.base_damage = variable_struct_exists(config, "damage") ? config[$ "damage"] : self.base_damage;
            self.damage_type = variable_struct_exists(config, "damage_type") ? config[$ "damage_type"] : self.damage_type;
            self.element_type = variable_struct_exists(config, "element_type") ? config[$ "element_type"] : self.element_type;

            self.speed = self.base_speed;
            self.lifetime = self.base_lifetime;
            self.damage = self.base_damage;

            if (self.element_type != ELEMENT_TYPE.NONE) {
                self.projectile_props = create_projectile_properties(self.damage, self.damage_type, self.element_type);
                self.projectile_props = apply_element_properties(self.projectile_props, self.element_type);
            }
        },

        apply_shooter_stats: function(shooter_obj) {
            if (!variable_instance_exists(shooter_obj, "creature")) return;

            self.shooter = shooter_obj;
            var stats = shooter_obj.creature.stats;
            
            // Check for and apply crit
            if (stats.crit_ready) {
                self.is_crit = true;
                stats.consume_crit();
            }

            var proj_speed_mult = stats.get_proj_speed();
            self.speed = self.base_speed * proj_speed_mult;
            self.lifetime = self.base_lifetime * sqrt(proj_speed_mult);
        },

        // Update method remains unchanged...
        update: function() {
            self.lifetime -= 1;
            return (self.lifetime <= 0);
        },

        on_hit: function(target) {
    if (!variable_instance_exists(target, "creature")) return false;
    if (self.shooter == target) return false;
    
    var final_damage = calculate_damage(self.damage, self.damage_type, target, self.element_type, self.shooter);
    
    var proj_shooter = self.shooter;
    var proj_props = self.projectile_props;

    // Debug the damage right before health modification
    var actual_damage = global.health_system.damage_creature(target, final_damage);

    if (proj_shooter != noone) {
        global.health_system.apply_life_steal(proj_shooter, actual_damage);
    }

    if (proj_props != undefined) {
        apply_status_effects(target, proj_props, proj_shooter);
    }
    return true;

        }
    };
}