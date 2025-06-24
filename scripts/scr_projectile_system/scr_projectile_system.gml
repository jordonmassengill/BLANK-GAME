// In scr_projectile_system
function create_base_projectile() {
    return {
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
        base_radius: undefined,

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
        },

        apply_shooter_stats: function(shooter_obj) {
            if (!variable_instance_exists(shooter_obj, "creature")) return;
            self.shooter = shooter_obj;
            var stats = shooter_obj.creature.stats;
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

        on_hit: function(target) {
            if (!variable_instance_exists(target, "entity") || !target.entity.has_component("health")) return false;
            if (self.shooter == target) return false;
            var final_damage = calculate_damage(self.damage, self.damage_type, target, self.element_type, self.shooter);
            var actual_damage = target.entity.health.take_damage(final_damage);
            if (target.entity.health.is_dead) {
                return true;
            }
            if (variable_instance_exists(target, "hit")) {
                target.hit(final_damage);
            }
            if (variable_global_exists("damage_number_system")) {
                global.damage_number_system.add_number(target, final_damage, false);
            }
            if (self.shooter != noone && variable_instance_exists(self.shooter, "entity") && self.shooter.entity.has_component("health")) {
                var life_steal_amount = self.shooter.creature.stats.get_life_steal();
                if (life_steal_amount > 0) {
                    var heal_amount = actual_damage * life_steal_amount;
                    self.shooter.entity.health.heal(heal_amount);
                    if (variable_global_exists("damage_number_system")) {
                        global.damage_number_system.add_number(self.shooter, heal_amount, true);
                    }
                }
            }
            
            // --- DEBUG BLOCK ---
            show_debug_message("--- On Hit Status Check ---");
            var element = self.element_type;
            show_debug_message("1. Projectile Element is: " + string(element));
            show_debug_message("2. Target definitely has status component (checked before calling).");
            var status_to_apply = undefined;
            switch (element) {
                case ELEMENT_TYPE.FIRE:   status_to_apply = EStatus.Burn;   break;
                case ELEMENT_TYPE.POISON: status_to_apply = EStatus.Poison; break;
            }
            if (status_to_apply != undefined) {
                show_debug_message("3. Applying effect: " + string(status_to_apply));
                target.entity.status.add_effect(status_to_apply, self.shooter);
            } else {
                show_debug_message("3. No status to apply for this element.");
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
                    global.health_system.damage_creature(target, damage);

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