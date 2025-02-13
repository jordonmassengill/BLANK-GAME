// obj_Martin Create Event (parent = obj_npc_parent)
event_inherited();

// Create creature properties
creature = create_creature_properties();

// Set Martin's specific stats
creature.max_health = 100;
creature.current_health = 100;
creature.stats.armor = 5;
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