// obj_orborange Step Event
event_inherited();

// Override just the effect function
function apply_effect(target) {
    target.creature.stats.proj_speed += 0.25;
}









/*
// obj_orborange Step Event for Life Steal
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // Add 50% life steal
        collider.creature.stats.life_steal += 0.5;
        
        // Destroy the orb
        instance_destroy();
    }
}
*/



// obj_orborange Step Event for Projectile Speed
// Override the pickup effect


/*
// obj_orborange Step Event for Rate of Fire
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // Increase rate of fire by 0.5 (50% faster)
        collider.creature.stats.rate_of_fire += 0.5;
        
        // Destroy the orb
        instance_destroy();
    }
}

*/

/*
// obj_orborange Step Event for Movement Speed
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // Add 2 to movement speed (base is 3)
        collider.creature.stats.move_speed += 20;
        
        // Destroy the orb
        instance_destroy();
    }
}

*/


/*
// obj_orborange Step Event for Armor
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // Add 20% damage reduction
        collider.creature.stats.armor += 20;
        
        // Destroy the orb
        instance_destroy();
    }
}
*/

/*
// obj_orborange Step Event for Max Health
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // First increase max health
        collider.entity.health.max_health += 50;
        
        // Then add health using the health system
        with(obj_health_system) {
            modify_health(collider, 200);
        }
        
        // Destroy the orb
        instance_destroy();
    }
}
*/

/*
// obj_orborange Step Event for Health Regen
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // Add health regen (5 health per second)
        collider.creature.stats.health_regen += 5;
        
        // Destroy the orb
        instance_destroy();
    }
}
*/

/*
// obj_orb_dot Step Event
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // Add DOT power boost
        collider.creature.stats.elemental_power_bonus += 1.0;  // This will double DOT damage
        
        // Optional: Visual or sound effect here
        
        // Destroy the orb
        instance_destroy();
    }
}

*/

/*
// obj_orb_magic Step Event
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // Add magic damage boost
        collider.creature.stats.magical_damage_bonus += 3.0;  // This will multiply magic damage by 4x
        
        // Optional: Visual or sound effect here
        
        // Destroy the orb
        instance_destroy();
    }
}
*/

/*
// obj_orb_physical Step Event
var collider = instance_place(x, y, all);
if (collider != noone) {
    // Check if the colliding object is a player
    if (variable_instance_exists(collider, "is_player")) {
        // Add physical damage boost
        collider.creature.stats.physical_damage_bonus += 3.0;  // This will multiply physical damage by 4x
        
        // Optional: Visual or sound effect here
        
        // Destroy the orb
        instance_destroy();
    }
}
*/