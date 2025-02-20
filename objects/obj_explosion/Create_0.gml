// obj_explosion Create Event
creator = noone;
base_damage = 50;
has_dealt_damage = false;
image_speed = 1;

// Deal damage to all valid targets in radius
function deal_damage() {
    if (has_dealt_damage || !creator) return;
    
    // Get radius using creator's stats
    var explosion_radius = creator.creature.stats.get_explosion_radius();
    
    // Define target types to check
    var target_types = [obj_enemy_parent, obj_npc_parent];
    var targets = ds_list_create();
    
    // Check each target type
    for (var i = 0; i < array_length(target_types); i++) {
        var num = collision_circle_list(x, y, explosion_radius, target_types[i], false, true, targets, false);
        
        if (num > 0) {
            for (var j = 0; j < num; j++) {
                var target = targets[| j];
                if (variable_instance_exists(target, "creature")) {
                    // Let the damage system handle all calculations
                    global.health_system.damage_creature(
                        target, 
                        calculate_damage(base_damage, DAMAGE_TYPE.AOE, target, ELEMENT_TYPE.NONE, creator)
                    );
                }
            }
        }
        ds_list_clear(targets);
    }
    
    ds_list_destroy(targets);
    has_dealt_damage = true;
}