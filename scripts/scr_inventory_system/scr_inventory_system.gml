// scr_inventory_system

function create_inventory(_slots = 10) {  // Optional parameter with default value
    return {
        items: array_create(_slots, undefined),
        
        add_item: function(item) {
            var len = array_length(items);
            for(var i = 0; i < len; i++) {
                if (items[i] == undefined) {
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
                    var item = items[slot];
                    items[@ slot] = undefined;
                    return item;
                }
            }
            return undefined;
        },
        
        get_item_count: function() {
            var count = 0;
            var len = array_length(items);
            for(var i = 0; i < len; i++) {
                if (items[i] != undefined) count++;
            }
            return count;
        }
    };
}