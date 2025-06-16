if (!menu_active) exit;

// Update animation variables
timer++;
glow_alpha += glow_dir * 0.02;
if (glow_alpha > 0.8 || glow_alpha < 0.2) glow_dir *= -1;

scanline_offset = (scanline_offset + 2) % 8;
active_pulse = 0.5 + 0.5 * abs(sin(timer / 10));

var player = instance_find(obj_player_creature_parent, 0);
if (!player) exit;

// ==================================================================
// FIX 1: Correctly calculate the total number of displayed orbs by
// summing the `count` of each stack, not just counting the stacks.
// ==================================================================
var total_display_count = 0;
var items = player.entity.inventory.items;
for (var i = 0; i < array_length(items); i++) {
    var item = items[i];
    if (item != undefined && array_contains(valid_types, item.type)) {
        // Add the count of the stack to the total
        total_display_count += item.count;
    }
}


// Input handling for panel switching
if (player.creature.input.right && cursor_position == "inventory") {
    cursor_position = "options";
    selected_item = 0;
}
if (player.creature.input.left && cursor_position == "options") {
    cursor_position = "inventory";
    selected_item = 0;
}

// Handle up/down navigation
if (player.creature.input.menu_up) {
    if (cursor_position == "inventory") {
        selected_item--;
        if (selected_item < 0) {
            // Use the corrected total_display_count here
            selected_item = total_display_count - 1;
        }
    } else {
        selected_item--;
        if (selected_item < 0) {
            selected_item = array_length(orb_types) - 1;
        }
    }
}

if (player.creature.input.menu_down) {
    if (cursor_position == "inventory") {
        selected_item++;
        // Use the corrected total_display_count here
        if (selected_item >= total_display_count) {
            selected_item = 0;
        }
    } else {
        selected_item++;
        if (selected_item >= array_length(orb_types)) {
            selected_item = 0;
        }
    }
}

// Handle selection
if (player.creature.input.menu_select) {
    if (cursor_position == "inventory") {
        // Toggle selection of inventory slot
        var display_index = selected_item;
        var array_index = array_get_index(selected_inventory_slots, display_index);
        
        if (array_index == -1) {
            array_push(selected_inventory_slots, display_index);
        } else {
            array_delete(selected_inventory_slots, array_index, 1);
        }
    } else {
        // ==================================================================
        // FIX 2: Correctly consume one orb at a time from a stack instead
        // of removing the entire stack.
        // ==================================================================
        
        // Convert all selected orbs to the chosen type
        var new_type_data = orb_types[selected_item];
        var num_orbs_to_exchange = array_length(selected_inventory_slots);
        
        // Do nothing if no orbs are selected to prevent errors
        if (num_orbs_to_exchange > 0) {
            // Step 1: Consume the selected orbs from the inventory ONE BY ONE.
            for (var i = 0; i < num_orbs_to_exchange; i++) {
                var display_index = selected_inventory_slots[i];
                
                // Find out which inventory slot this displayed orb belongs to
                var slot_index = ds_map_find_value(display_to_inventory_slot, display_index);
                
                if (slot_index != undefined) {
                    var item_to_consume = player.entity.inventory.items[slot_index];
                    if (item_to_consume != undefined) {
                        // Use the consume_item function, which correctly handles stacks
                        player.entity.inventory.consume_item(item_to_consume.type);
                    }
                }
            }
            
            // Step 2: Add the new orbs to the inventory.
            for (var i = 0; i < num_orbs_to_exchange; i++) {
                // The inventory component handles creating the orb data.
                player.entity.inventory.add_item("orb_" + new_type_data.type);
            }
            
            // Step 3: Clear selections and reset the cursor.
            selected_inventory_slots = [];
            selected_item = 0; // Reset cursor to the top of the list
        }
    }
}

// Handle back/cancel
if (player.creature.input.menu_back) {
    if (array_length(selected_inventory_slots) > 0) {
        selected_inventory_slots = [];
    } else {
        menu_active = false;
        instance_activate_all();
        buffer_delete(grid_buffer);
    }
}