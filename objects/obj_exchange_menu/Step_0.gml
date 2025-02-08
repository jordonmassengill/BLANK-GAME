// obj_exchange_menu Step Event
if (!menu_active) exit;
var player = instance_find(obj_player_creature_parent, 0);
if (!player) exit;

// Calculate total display count first
var total_display_count = 0;
var items = player.creature.inventory.items;
for (var i = 0; i < array_length(items); i++) {
    if (items[i] != undefined && array_contains(valid_types, items[i].type)) {
        var count = variable_struct_exists(items[i], "count") ? items[i].count : 1;
        total_display_count += count;
    }
}

// Handle left/right to switch between columns
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
        // Convert all selected orbs to the chosen type
        var new_type = orb_types[selected_item];
        var converted_count = 0;
        
        // First remove all selected items
        for (var i = 0; i < array_length(selected_inventory_slots); i++) {
            var display_index = selected_inventory_slots[i];
            var inventory_slot = ds_map_find_value(display_to_inventory_slot, display_index);
            if (inventory_slot != undefined) {
                player.creature.inventory.items[@ inventory_slot] = undefined;
                converted_count++;
            }
        }
        
        // Create new orb template
        var new_orb = {
            name: new_type.name,
            color: new_type.color,
            type: new_type.type,
            description: "Exchanged orb of " + new_type.type + " type."
        };
        
        // Add orbs for each conversion
        repeat(converted_count) {
            player.creature.inventory.add_item(new_orb);
        }
        
        // Clear selections
        selected_inventory_slots = [];
    }
}

// Handle back/cancel
if (player.creature.input.menu_back) {
    if (array_length(selected_inventory_slots) > 0) {
        // Clear selections if we have any
        selected_inventory_slots = [];
    } else {
        // Exit menu if no selections
        menu_active = false;
        instance_activate_all();
    }
}