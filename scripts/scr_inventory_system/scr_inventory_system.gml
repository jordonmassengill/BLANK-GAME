// scr_inventory_system
function create_inventory(_slots = 16) {  // Changed default to 16
    return {
        items: array_create(_slots, undefined),
        
        add_item: function(item) {
            // First try to stack with existing item of same type
            var len = array_length(items);
            for(var i = 0; i < len; i++) {
                if (items[i] != undefined && items[i].type == item.type) {
                    if (!variable_struct_exists(items[i], "count")) {
                        items[i].count = 1;
                    }
                    items[i].count++;
                    return true;
                }
            }
            
            // If no stack found, find first empty slot
            for(var i = 0; i < len; i++) {
                if (items[i] == undefined) {
                    item.count = 1;  // Add count to new items
                    items[@ i] = item;
                    return true;
                }
            }
            return false;
        },
        
        remove_item: function(slot) {
            var len = array_length(items);
            if (slot >= 0 && slot < len) {
                if (items[slot] != undefined) {
                    if (variable_struct_exists(items[slot], "count") && items[slot].count > 1) {
                        items[slot].count--;
                        return items[slot];
                    } else {
                        var item = items[slot];
                        items[@ slot] = undefined;
                        return item;
                    }
                }
            }
            return undefined;
        }
    };
}