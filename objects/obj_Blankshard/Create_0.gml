// Create Event for obj_Blankshard (parent = obj_pickup_parent)
sharditem = {
    name: "Blank Shard",
    color: c_dkgray,  // Darker gray to differentiate from full orb
    type: "shard",
    description: "Collect 5 to form a Blank Orb"
}

function apply_effect(target) {
    if (variable_instance_exists(target, "creature") && 
        variable_struct_exists(target.creature, "inventory")) {
        
        // Look for existing shards
        var found_shards = undefined;
        var found_slot = -1;
        var items = target.creature.inventory.items;
        
        for(var i = 0; i < array_length(items); i++) {
            if (items[i] != undefined && items[i].type == "shard") {
                found_shards = items[i];
                found_slot = i;
                break;
            }
        }
        
        // If we found shards, add to count
        if (found_shards != undefined) {
            found_shards.count++;
            
            // Check if we now have 5 shards
            if (found_shards.count >= 5) {
                // Remove the shards
                target.creature.inventory.items[@ found_slot] = undefined;
                
                // Create blank orb
                var blank_orb = {
                    name: "Blank Orb",
                    color: c_gray,
                    type: "blank",
                    description: "Can be exchanged for any orb type at an exchange platform",
                    count: 1
                };
                
                // Add the blank orb to inventory
                target.creature.inventory.add_item(blank_orb);
            }
        } else {
            // No existing shards, add new shard item
            target.creature.inventory.add_item(sharditem);
        }
        
        return true;
    }
    return false;
}