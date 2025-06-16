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

        /// @function _add_or_stack_item(item_struct)
        /// @description Scans for a matching item to stack or adds to an empty slot.
        _add_or_stack_item: function(item_struct) {
            // First, try to find an existing stack of the same type
            for (var i = 0; i < self.max_slots; i++) {
                var slot_item = self.items[i];
                if (slot_item != undefined && slot_item.type == item_struct.type) {
                    // Found a match! Increment the count.
                    if (!variable_struct_exists(slot_item, "count")) {
                        slot_item.count = 1; // Initialize count if it doesn't exist
                    }
                    slot_item.count++;
                    return true; // Success!
                }
            }

            // If no existing stack was found, add it to the first empty slot
            for (var i = 0; i < self.max_slots; i++) {
                if (self.items[i] == undefined) {
                    item_struct.count = 1; // Start the new stack with a count of 1
                    self.items[@ i] = item_struct;
                    return true; // Success!
                }
            }

            show_debug_message("Inventory is full! Cannot add " + item_struct.name);
            return false; // No empty slots found
        },
		
		/// @function add_item(item_id)
		/// @description The core logic for adding an item and applying its effect.
		/// @param {string} item_id A unique string identifying the item to add.
		add_item: function(item_id) {
			var inst = self.owner.owner_instance; // Shortcut to the instance
			
			// This switch statement is now the "brain" for all item effects.
			switch (item_id) {
				
				// --- UPGRADE ORBS ---
				case "orb_life":
				case "orb_power":
				case "orb_speed":
				case "orb_defense":
				case "orb_manifest":
				case "orb_finesse":
				case "orb_blank":
					var orb_data = self.get_orb_data(item_id);
					return self._add_or_stack_item(orb_data);
				
				// --- BLANK SHARD (Special Case) ---
				case "shard_blank":
					var shard_count = self.count_item("shard");
					
					if (shard_count >= 4) {
						for (var i = 0; i < 4; i++) {
							self.consume_item("shard");
						}
						return self.add_item("orb_blank");
					} else {
						var shard_data = { name: "Blank Shard", color: c_dkgray, type: "shard" };
						return self._add_or_stack_item(shard_data);
					}
					
				// --- IMMEDIATE EFFECT PICKUPS ---
				case "pickup_jetpack":
					inst.creature.has_jetpack = true;
					inst.creature.jetpack_fuel += JETPACK_FUEL_PICKUP_AMOUNT;
					return true;
			}
			
			show_debug_message("Warning: Unrecognized item_id '" + item_id + "' in inventory component.");
			return false;
		},
		
		/// @function remove_item(slot)
		/// @description Removes an item from a specific slot in the inventory.
		remove_item: function(slot) {
			if (slot >= 0 && slot < array_length(self.items) && self.items[slot] != undefined) {
				var item = self.items[slot];
				self.items[@ slot] = undefined;
				return item;
			}
			return undefined;
		},
		
		/// @function consume_item(item_type)
		/// @description Finds the first item of a given type and removes it.
		consume_item: function(item_type) {
			for (var i = 0; i < self.max_slots; i++) {
                var slot_item = self.items[i];
				if (slot_item != undefined && slot_item.type == item_type) {
                    if (variable_struct_exists(slot_item, "count") && slot_item.count > 1) {
                        slot_item.count--;
                    } else {
					    self.remove_item(i);
                    }
					return true;
				}
			}
			return false;
		},
		
		/// @function count_item(item_type)
		/// @description Counts how many items of a given type are in the inventory.
		count_item: function(item_type) {
			var count = 0;
			for (var i = 0; i < self.max_slots; i++) {
				var slot_item = self.items[i];
				if (slot_item != undefined && slot_item.type == item_type) {
                    if (variable_struct_exists(slot_item, "count")) {
                        count += slot_item.count;
                    } else {
                        count++;
                    }
				}
			}
			return count;
		},
		
		/// @function get_inventory_summary()
		/// @description Processes the inventory and returns a simple summary array for drawing.
		get_inventory_summary: function() {
			var summary_map = ds_map_create();

			// Step 1: Iterate through the raw inventory and aggregate items by type.
			for (var i = 0; i < self.max_slots; i++) {
				var item = self.items[i];
				if (item != undefined && is_struct(item)) {
					var item_type = item.type;
					
					// If we haven't seen this type yet, create a summary entry for it.
					if (!ds_map_exists(summary_map, item_type)) {
						var summary_entry = {
							name: item.name,
							color: item.color,
							type: item.type,
							count: 0
						};
						ds_map_add(summary_map, item_type, summary_entry);
					}
					
					// Add the count of the current stack to the summary entry.
					var existing_entry = summary_map[? item_type];
					existing_entry.count += item.count;
				}
			}

			// Step 2: Convert the map of summary structs into a simple array.
			var summary_list = [];
			var key = ds_map_find_first(summary_map);
			while (!is_undefined(key)) {
				array_push(summary_list, summary_map[? key]);
				key = ds_map_find_next(summary_map, key);
			}
			
			ds_map_destroy(summary_map);
			return summary_list;
		},
		
		//----------------------------------------------------------------------
		// HELPER METHODS
		//----------------------------------------------------------------------
		
		/// @function get_orb_data(orb_id)
		/// @description A helper to create the data struct for upgrade orbs.
		get_orb_data: function(orb_id) {
			switch(orb_id) {
				case "orb_life":	 return { name: "Life Orb", color: c_red, type: "life" };
				case "orb_power":	 return { name: "Power Orb", color: c_blue, type: "power" };
				case "orb_speed":	 return { name: "Speed Orb", color: c_green, type: "speed" };
				case "orb_defense":  return { name: "Defense Orb", color: c_purple, type: "defense" };
				case "orb_manifest": return { name: "Manifest Orb", color: c_orange, type: "manifest" };
				case "orb_finesse":  return { name: "Finesse Orb", color: make_colour_rgb(139, 69, 19), type: "finesse" };
				case "orb_blank":	 return { name: "Blank Orb", color: c_gray, type: "blank" };
				default:			 return undefined;
			}
		}

	}.init(self);
}
