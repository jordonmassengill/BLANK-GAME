/// @function create_weapon_component(owner_entity)
/// @description [REFACTORED] Creates a component to manage an entity's weapons, firing, and inventory.
function create_weapon_component(owner_entity) {
    return {
        // ... (properties and other methods like pickup_weapon, drop_weapon, etc. remain the same) ...

        owner: owner_entity,
        slots: [undefined, undefined],
        active_slot: 0,
        init: function() { return self; },
        can_fire: function() {
            var active_weapon = self.slots[self.active_slot];
            if (active_weapon == undefined) return false;
            return (active_weapon.data.cooldown <= 0);
        },
        pickup_weapon: function(weapon_name, pickup_obj_index) {
            if ((self.slots[0] != undefined && self.slots[0].name == weapon_name) ||
                (self.slots[1] != undefined && self.slots[1].name == weapon_name)) {
                return false;
            }
            var new_weapon = { name: weapon_name, data: { cooldown: 0, pickup_obj_index: pickup_obj_index } };
            if (self.slots[0] == undefined) {
                self.slots[0] = new_weapon;
                self.active_slot = 0;
                return true;
            }
            if (self.slots[1] == undefined) {
                self.slots[1] = new_weapon;
                self.active_slot = 1;
                return true;
            }
            var weapon_to_drop = self.slots[self.active_slot];
            self.drop_weapon(weapon_to_drop.data.pickup_obj_index);
            self.slots[self.active_slot] = new_weapon;
            return true;
        },
        drop_weapon: function(pickup_obj_index) {
            if (pickup_obj_index == undefined) return;
            var inst = self.owner.owner_instance;
            var drop = instance_create_layer(inst.x, inst.y, "Instances", pickup_obj_index);
            drop.pickup_cooldown = 60;
        },
        swap_active_weapon: function() {
            if (self.slots[0] != undefined && self.slots[1] != undefined) {
                self.active_slot = 1 - self.active_slot;
            }
        },
        update: function() {
            for (var i = 0; i < 2; i++) {
                if (self.slots[i] != undefined && self.slots[i].data.cooldown > 0) {
                    self.slots[i].data.cooldown -= 1;
                }
            }
        },

        /// @function fire(target, is_melee)
        /// @description [UPDATED] Fires the active weapon using its data-driven definition and spawn offsets.
        fire: function(target = noone, is_melee = false) {
            var active_weapon_data = self.slots[self.active_slot];
            if (active_weapon_data == undefined || active_weapon_data.data.cooldown > 0) return;

            var weapon_name_to_fire = active_weapon_data.name;
            if (is_melee && weapon_name_to_fire == "shotgun") {
                weapon_name_to_fire = "orchyde_melee";
            }
            var weapon_def = global.weapon_defs[$ weapon_name_to_fire];
            if (weapon_def == undefined) {
                show_debug_message("Warning: Weapon definition not found for '" + weapon_name_to_fire + "'");
                return;
            }

            var inst = self.owner.owner_instance;
            var creature = inst.creature;
            var aim_angle = 0;
            var shot_fired = false;
            
            // --- AIMING LOGIC (Unchanged) ---
            if (instance_exists(target)) {
                 aim_angle = point_direction(inst.x, inst.y, target.x, target.y);
            } else {
                if (creature.input.using_controller) {
                    if (abs(creature.input.aim_x) > 0.2 || abs(creature.input.aim_y) > 0.2) {
                        aim_angle = point_direction(0, 0, creature.input.aim_x, creature.input.aim_y);
                    } else {
                        aim_angle = (inst.sprite_direction == 1) ? 0 : 180;
                    }
                } else {
                    aim_angle = point_direction(inst.x, inst.y, creature.input.target_x, creature.input.target_y);
                }
            }

            // --- NEW SPAWN OFFSET LOGIC ---
            var offset_h = weapon_def.spawn_offset_h ?? 0;
            var offset_v = weapon_def.spawn_offset_v ?? 0;
            
            var offset_x_final = lengthdir_x(offset_h, aim_angle);
            var offset_y_final = lengthdir_y(offset_h, aim_angle) + offset_v;
            
            // This special case prevents vertical offset from being ignored when firing perfectly horizontally.
            if (aim_angle == 0 || aim_angle == 180) {
                offset_y_final = offset_v;
            }

            var spawn_x = inst.x + offset_x_final;
            var spawn_y = inst.y + offset_y_final;
            // --- END OF NEW LOGIC ---

            var proj_obj = weapon_def.projectile_object;
            
            switch (weapon_def.fire_pattern) {
                case "single":
                    var proj = instance_create_layer(spawn_x, spawn_y, "Instances", proj_obj); // USE new spawn coords
                    proj.projectile.apply_shooter_stats(inst);
                    proj.direction = aim_angle;
                    proj.image_angle = aim_angle;
                    shot_fired = true;
                    break;
                    
                case "spread":
                    for (var i = 0; i < weapon_def.pellet_count; i++) {
                        var final_angle = aim_angle + random_range(-weapon_def.spread_angle / 2, weapon_def.spread_angle / 2);
                        var proj = instance_create_layer(spawn_x, spawn_y, "Instances", proj_obj); // USE new spawn coords
                        proj.projectile.apply_shooter_stats(inst);
                        proj.direction = final_angle;
                        proj.image_angle = final_angle;
                    }
                    shot_fired = true;
                    break;
                    
                case "arc":
                    var proj = instance_create_layer(spawn_x, spawn_y, "Instances", proj_obj); // USE new spawn coords
                    proj.projectile.apply_shooter_stats(inst);
                    proj.direction = aim_angle;
                    proj.image_angle = aim_angle;
                    proj.vspeed = -3.3;
                    proj.gravity = 0.08;
                    shot_fired = true;
                    break;
                
                case "melee":
                    // Melee uses its own offset from the definition.
                    var hitbox_x = inst.x + lengthdir_x(weapon_def.hitbox_offset, aim_angle);
                    var hitbox_y = inst.y - 16;
                    var hitbox = instance_create_layer(hitbox_x, hitbox_y, "Instances", proj_obj);
                    hitbox.creator = inst;
                    hitbox.damage = weapon_def.hitbox_damage;
                    hitbox.life_time = weapon_def.hitbox_lifetime;
                    shot_fired = true;
                    break;
            }
            
            if (shot_fired) {
                var rof = creature.stats.get_rate_of_fire();
                active_weapon_data.data.cooldown = weapon_def.base_cooldown / rof;
            }
        }
    }.init();
}