if (!menu_active) exit;

// Update animation variables
timer++;
glow_alpha += glow_dir * 0.02;
if (glow_alpha > 0.8 || glow_alpha < 0.2) glow_dir *= -1;

scanline_offset = (scanline_offset + 2) % 8;
active_pulse = 0.5 + 0.5 * abs(sin(timer / 10));

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
        var array_index = array_get_index(selected_inventory_slots, display_index); // Fixed here
        
        if (array_index == -1) {
            array_push(selected_inventory_slots, display_index);
        } else {
            array_delete(selected_inventory_slots, array_index, 1);
        }
    } else {
        // Convert all selected orbs to the chosen type
        var new_type = orb_types[selected_item];
        var new_orbs_to_create = array_length(selected_inventory_slots);
        
        // Sort selections in descending order to avoid index shifting
        array_sort(selected_inventory_slots, function(a, b) { return b - a; });
        
        // First pass: Create array of inventory slots to remove
        var slots_to_clear = array_create(new_orbs_to_create);
        for (var i = 0; i < new_orbs_to_create; i++) {
            var display_index = selected_inventory_slots[i];
            slots_to_clear[i] = ds_map_find_value(display_to_inventory_slot, display_index);
        }
        
        // Sort removal slots in descending order
        array_sort(slots_to_clear, function(a, b) { return b - a; });
        
        // Remove the orbs from inventory
        for (var i = 0; i < array_length(slots_to_clear); i++) {
            if (slots_to_clear[i] != undefined) {
                player.creature.inventory.remove_item(slots_to_clear[i]);
            }
        }
        
        // Add new orbs
        for (var i = 0; i < new_orbs_to_create; i++) {
            var new_orb = {
                name: new_type.name,
                color: new_type.color,
                type: new_type.type,
                description: "Exchanged orb of " + new_type.type + " type."
            };
            player.creature.inventory.add_item(new_orb);
        }
        
        // Clear selections
        selected_inventory_slots = [];
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