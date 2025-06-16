/// @function create_inventory_component(max_slots)
/// @description Creates a component to manage an entity's inventory and item effects.
/// @param {real} max_slots The number of item slots this inventory will have.
function create_inventory_component(max_slots = 16) {
	return {
		//----------------------------------------------------------------------
		// PROPERTIES
		//----------------------------------------------------------------------
		owner: undefined,
		items: array_create(max_slots, undefined),
		max_slots: max_slots,

		//----------------------------------------------------------------------
		// METHODS
		//----------------------------------------------------------------------
		
		/// @function init(owner_entity)
		/// @description Links the component to its owner entity.
		init: function(owner_entity) {
			self.owner = owner_entity;
			return self;
		},

		/// @function add_item(item_id)
		/// @description The core logic for adding an item and applying its effect.
		/// @param {string} item_id A unique string identifying the item to add.
		add_item: function(item_id) {
			var inst = self.owner.owner_instance; // Shortcut to the instance
			
			// This switch statement is now the "brain" for all item effects.
			switch (item_id) {
				
				// --- UPGRADE ORBS ---
				// These get added to the `items` array to be spent later.
				case "orb_life":
				case "orb_power":
				case "orb_speed":
				case "orb_defense":
				case "orb_manifest":
				case "orb_finesse":
				case "orb_blank":
					var orb_data = self.get_orb_data(item_id);
					return self.add_to_first_open_slot(orb_data);
				
				// --- BLANK SHARD (Special Case) ---
				case "shard_blank":
					var shard_count = self.count_item("shard");
					
					if (shard_count >= 4) { // This pickup is the 5th shard
						// Remove the 4 existing shards from inventory
						for (var i = 0; i < 4; i++) {
							self.consume_item("shard");
						}
						// Add a full blank orb instead
						return self.add_item("orb_blank");
					} else {
						// Otherwise, just add one more shard
						var shard_data = { name: "Blank Shard", color: c_dkgray, type: "shard" };
						return self.add_to_first_open_slot(shard_data);
					}
					
				// --- IMMEDIATE EFFECT PICKUPS ---
				// These apply an effect instantly and don't take up an inventory slot.
				case "pickup_jetpack":
					inst.creature.has_jetpack = true;
					inst.creature.jetpack_fuel += JETPACK_FUEL_PICKUP_AMOUNT;
					return true; // Return true to signal success
			}
			
			// If the item_id wasn't found in the switch
			show_debug_message("Warning: Unrecognized item_id '" + item_id + "' in inventory component.");
			return false;
		},
		
		/// @function remove_item(slot)
		/// @description Removes an item from a specific slot in the inventory.
		remove_item: function(slot) {
			var len = array_length(self.items);
			if (slot >= 0 && slot < len && self.items[slot] != undefined) {
				var item = self.items[slot];
				self.items[@ slot] = undefined;
				return item;
			}
			return undefined;
		},
		
		/// @function consume_item(item_type)
		/// @description Finds the first item of a given type and removes it. Useful for UI.
		consume_item: function(item_type) {
			for (var i = 0; i < self.max_slots; i++) {
				if (self.items[i] != undefined && self.items[i].type == item_type) {
					self.remove_item(i);
					return true; // Success
				}
			}
			return false; // Nothing to consume
		},
		
		/// @function count_item(item_type)
		/// @description Counts how many items of a given type are in the inventory.
		count_item: function(item_type) {
			var count = 0;
			for (var i = 0; i < self.max_slots; i++) {
				if (self.items[i] != undefined && self.items[i].type == item_type) {
					count++;
				}
			}
			return count;
		},
		
		//----------------------------------------------------------------------
		// HELPER METHODS
		//----------------------------------------------------------------------
		
		/// @function add_to_first_open_slot(item_struct)
		/// @description Finds the first empty slot and adds the item struct.
		add_to_first_open_slot: function(item_struct) {
			for (var i = 0; i < self.max_slots; i++) {
				if (self.items[i] == undefined) {
					self.items[@ i] = item_struct;
					return true; // Success
				}
			}
			show_debug_message("Inventory is full!");
			return false; // Failure
		},
		
		/// @function get_orb_data(orb_id)
		/// @description A helper to create the data struct for upgrade orbs.
		get_orb_data: function(orb_id) {
			switch(orb_id) {
				case "orb_life":     return { name: "Life Orb", color: c_red, type: "life" };
				case "orb_power":    return { name: "Power Orb", color: c_blue, type: "power" };
				case "orb_speed":    return { name: "Speed Orb", color: c_green, type: "speed" };
				case "orb_defense":  return { name: "Defense Orb", color: c_purple, type: "defense" };
				case "orb_manifest": return { name: "Manifest Orb", color: c_orange, type: "manifest" };
				case "orb_finesse":  return { name: "Finesse Orb", color: make_colour_rgb(139, 69, 19), type: "finesse" };
				case "orb_blank":    return { name: "Blank Orb", color: c_gray, type: "blank" };
				default:             return undefined;
			}
		}

	}.init(self); // Call init on creation to link the component to itself
}