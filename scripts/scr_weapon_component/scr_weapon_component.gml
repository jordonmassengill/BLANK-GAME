/// @function create_weapon_component(owner_entity)
/// @description Creates a component to manage an entity's weapons, firing, and inventory
/// @param {struct} owner_entity - The parent entity struct (the one with .owner_instance).
function create_weapon_component(owner_entity) {
	return {
		//----------------------------------------------------------------------
		// PROPERTIES
		//----------------------------------------------------------------------
		owner: owner_entity,
		slots: [undefined, undefined],
		active_slot: 0,

		//----------------------------------------------------------------------
		// METHODS
		//----------------------------------------------------------------------
		
		can_fire: function() {
			var active_weapon = self.slots[self.active_slot];
			if (active_weapon == undefined) {
				return false;
			}
			return (active_weapon.data.cooldown <= 0);
		},

		init: function() {
			return self;
		},

		pickup_weapon: function(weapon_name, weapon_data) {
			if ((self.slots[0] != undefined && self.slots[0].name == weapon_name) ||
			    (self.slots[1] != undefined && self.slots[1].name == weapon_name)) {
				return false;	
			}

			var new_weapon = { name: weapon_name, data: weapon_data };
			new_weapon.data.cooldown = 0;

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
			self.drop_weapon(weapon_to_drop.name, weapon_to_drop.data.pickup_obj_index);
			
			self.slots[self.active_slot] = new_weapon;
			return true;
		},

		drop_weapon: function(weapon_name, pickup_obj_index) {
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

		fire: function(target = noone, is_melee = false) {
			var active_weapon = self.slots[self.active_slot];
			
			if (active_weapon == undefined || active_weapon.data.cooldown > 0) return;
			
			var inst = self.owner.owner_instance;
			var creature = inst.creature;
			var aim_angle = 0;
			var shot_fired = false;
			
			// AIMING LOGIC
			if (is_struct(target) || instance_exists(target)) {
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

			// *** RESTRUCTURED FIRING LOGIC TO FIX SCOPE ISSUE ***

			// 1. Decide which action to take
			var action_name = active_weapon.name;
			if (is_melee && action_name == "shotgun") {
				action_name = "orchyde_melee"; // Use a unique name for the melee action
			}
			
			// 2. Execute the action inside the 'with' block
			with(obj_weapon_system) {
				switch(action_name) {
					case "orchyde_melee":
						 var hitbox = instance_create_layer(inst.x + lengthdir_x(20, aim_angle), inst.y - 16, "Instances", obj_Orchyde_melee_hitbox);
						 hitbox.creator = inst;
						 hitbox.damage = 10;
						 hitbox.life_time = 15;
						 shot_fired = true;
						 break;
					case "fireball":    shot_fired = shoot_fireball(inst, aim_angle); break;
					case "bomb":        shot_fired = shoot_bomb(inst, aim_angle); break;
					case "dart":        shot_fired = shoot_dart(inst, aim_angle); break;
					case "waterball":   shot_fired = shoot_waterball(inst, aim_angle); break;
					case "iceball":     shot_fired = shoot_iceball(inst, aim_angle); break;
					case "electro":     shot_fired = shoot_electro(inst, aim_angle); break;
					case "ghoststrike": shot_fired = shoot_ghoststrike(inst, aim_angle); break;
					case "ghostball":   shot_fired = shoot_ghostball(inst, aim_angle); break;
					case "shotgun":     shot_fired = shoot_shotgun(inst, aim_angle); break;
				}
			}
			
			// 3. Set Cooldown
			if (shot_fired) {
				var rof = creature.stats.get_rate_of_fire();
				active_weapon.data.cooldown = active_weapon.data.base_cooldown / rof;
			}
		}

	}.init();
}