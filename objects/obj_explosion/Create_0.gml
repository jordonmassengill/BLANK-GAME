// obj_explosion Create Event
creator = noone;
base_damage = 50;  // Explosion holds its own base damage
has_dealt_damage = false;
image_speed = 1;

show_debug_message("Explosion created!");

// Deal damage to all enemies in radius
function deal_damage() {
    if (has_dealt_damage || !creator) return;
    
    // Calculate damage using creator's Area of Effect stat
    var final_damage = base_damage * creator.creature.stats.get_area_of_effect();
    // Get radius using creator's stats
    var explosion_radius = creator.creature.stats.get_explosion_radius();
    
    var targets = ds_list_create();
    var num = collision_circle_list(x, y, explosion_radius, obj_enemy_parent, false, true, targets, false);
    
    if (num > 0) {
        for (var i = 0; i < num; i++) {
            var target = targets[| i];
            if (variable_instance_exists(target, "creature")) {
                global.health_system.damage_creature(target, final_damage);
                show_debug_message("Explosion dealing " + string(final_damage) + " damage to enemy");
            }
        }
    }
    
    ds_list_destroy(targets);
    has_dealt_damage = true;
    show_debug_message("Explosion damage dealt!");
}