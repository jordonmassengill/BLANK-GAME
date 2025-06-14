// obj_Martin Create Event (parent = obj_npc_parent)
event_inherited();

// Create creature properties for non-health related functionality
creature = create_creature_properties();

// Setup component entity
entity = {};
entity.owner_instance = id;
add_component(entity, "health", create_health_component(1000));

// Set Martin's specific stats
entity.health.max_health = 1000;
entity.health.current_health = 1000;
creature.stats.armor = 0;
creature.stats.resistance = 5;

// Movement and patrol properties
walk_speed = 0.5;
direction = choose(0, 180);
moving_right = (direction == 0);
is_patrolling = true;
patrol_point_left = x - 100;
patrol_point_right = x + 100;
edge_check_dist = 32;
is_shooting = false;
is_melee_attacking = false;
player_in_range = false;

// Sprite properties
sprite_index = sMartinWalk;
image_speed = 1;
image_xscale = (direction == 0) ? 1 : -1;

// Create shop inventory
shop = create_shop_inventory();
shop_add_item(shop, "Jetpack", 120, obj_jpack, "Allows double jumping and hovering");
shop_add_item(shop, "Life Orb", 50, obj_Lifeupgrade, "Upgrades health-related stats");
shop_add_item(shop, "Power Orb", 50, obj_Powerupgrade, "Upgrades damage-related stats");
shop_add_item(shop, "Speed Orb", 50, obj_Speedupgrade, "Upgrades movement and attack speed");
shop_add_item(shop, "Defense Orb", 50, obj_Defenseupgrade, "Upgrades defensive stats");

// Create shop menu
shop_menu = create_shop_menu();

// Add hit function
hit = function(damage_amount = 0) {
    // Apply damage using the health component
    if (damage_amount > 0 && variable_struct_exists(entity, "health")) {
        entity.health.take_damage(damage_amount);
    }
    
    return true;
};