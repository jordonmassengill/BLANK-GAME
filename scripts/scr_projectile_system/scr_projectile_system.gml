// In scr_projectile_system
function create_base_projectile() {
    return {
        // Base properties
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
        is_crit: false,
        base_radius: undefined,  // Add this for AOE

        initialize: function(config) {
            self.base_speed = variable_struct_exists(config, "speed") ? config[$ "speed"] : self.base_speed;
            self.base_lifetime = variable_struct_exists(config, "lifetime") ? config[$ "lifetime"] : self.base_lifetime;
            self.base_damage = variable_struct_exists(config, "damage") ? config[$ "damage"] : self.base_damage;
            self.damage_type = variable_struct_exists(config, "damage_type") ? config[$ "damage_type"] : self.damage_type;
            self.element_type = variable_struct_exists(config, "element_type") ? config[$ "element_type"] : self.element_type;
            self.base_radius = variable_struct_exists(config, "base_radius") ? config[$ "base_radius"] : undefined;

            self.speed = self.base_speed;
            self.lifetime = self.base_lifetime;
            self.damage = self.base_damage;

            // Create projectile properties, passing base_radius for AOE
            if (self.element_type != ELEMENT_TYPE.NONE || self.damage_type == DAMAGE_TYPE.AOE) {
                self.projectile_props = create_projectile_properties(
                    self.damage, 
                    self.damage_type, 
                    self.element_type,
                    self.base_radius
                );
                if (self.element_type != ELEMENT_TYPE.NONE) {
                    self.projectile_props = apply_element_properties(self.projectile_props, self.element_type);
                }
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

        update: function() {
            self.lifetime -= 1;
            return (self.lifetime <= 0);
        },

        // Update to the on_hit function in create_base_projectile
on_hit: function(target) {
    if (!variable_instance_exists(target, "entity") || 
        !variable_struct_exists(target.entity, "health")) return false;
    if (self.shooter == target) return false;
    
    var final_damage = calculate_damage(self.damage, self.damage_type, target, self.element_type, self.shooter);
    
    var proj_shooter = self.shooter;
    var proj_props = self.projectile_props;

    // Apply damage directly to the health component
    var actual_damage = target.entity.health.take_damage(final_damage);


	if (!instance_exists(target)) {
	    return true; // The hit was successful; the target just doesn't exist anymore.
	}
    
	// Now it's safe to continue with the rest of the function...
	if (target.entity.health.is_dead) {
	    return true; 
	}

    // Call hit function if it exists
    if (variable_instance_exists(target, "hit")) {
        target.hit(final_damage);
    }
    
    // Show damage numbers
    if (variable_global_exists("damage_number_system")) {
        global.damage_number_system.add_number(target, final_damage, false);
    }
    
    // Apply life steal
    if (proj_shooter != noone && 
        variable_instance_exists(proj_shooter, "creature") && 
        variable_struct_exists(proj_shooter.creature, "stats") && 
        variable_struct_exists(proj_shooter.creature.stats, "get_life_steal") &&
        variable_instance_exists(proj_shooter, "entity") && 
        variable_struct_exists(proj_shooter.entity, "health")) {
        
        var life_steal_amount = proj_shooter.creature.stats.get_life_steal();
        if (life_steal_amount > 0) {
            var heal_amount = actual_damage * life_steal_amount;
            proj_shooter.entity.health.heal(heal_amount);
            
            // Show healing numbers
            if (variable_global_exists("damage_number_system")) {
                global.damage_number_system.add_number(proj_shooter, heal_amount, true);
            }
        }
    }
    
    // Apply status effects
    if (proj_props != undefined) {
        apply_status_effects(target, proj_props, proj_shooter);
    }
    
    return true;
}
    };
}

function apply_aoe_damage(xx, yy, source, base_radius, base_damage, element_type = ELEMENT_TYPE.NONE) {
    var final_radius = base_radius;
    var targets_hit = 0;
    
    // Get enhanced radius if source has stats
    if (variable_instance_exists(source, "creature")) {
        final_radius = base_radius * source.creature.stats.get_aoe_radius();
    }
    
    // Create projectile properties for element effects if needed
    var proj_props = undefined;
    if (element_type != ELEMENT_TYPE.NONE) {
        // Pass base_radius when creating projectile properties
        proj_props = create_projectile_properties(base_damage, DAMAGE_TYPE.AOE, element_type, base_radius);
        proj_props = apply_element_properties(proj_props, element_type);
    }
    
    // Find all valid targets
    var target_types = [obj_enemy_parent, obj_npc_parent];
    var targets = ds_list_create();
    
    // Check each target type
    for (var i = 0; i < array_length(target_types); i++) {
        var num = collision_circle_list(xx, yy, final_radius, target_types[i], false, true, targets, false);
        
        if (num > 0) {
            for (var j = 0; j < num; j++) {
                var target = targets[| j];
                if (variable_instance_exists(target, "creature")) {
                    // Calculate and apply damage
                    var damage = calculate_damage(base_damage, DAMAGE_TYPE.AOE, target, element_type, source);
                    target.entity.health.take_damage(damage);
                    
                    // Apply element effects if any
                    if (proj_props != undefined) {
                        apply_status_effects(target, proj_props, source);
                    }
                    
                    targets_hit++;
                }
            }
        }
        ds_list_clear(targets);
    }
    
    ds_list_destroy(targets);
    
    // Return result struct
    return {
        radius: final_radius,
        hits: targets_hit
    };
}