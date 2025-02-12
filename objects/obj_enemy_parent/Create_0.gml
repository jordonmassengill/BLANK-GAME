// obj_enemy_parent Create Event (parent = obj_creature_parent)
event_inherited();  // Get creature stuff
is_enemy = true;

hit_timer = 0;
hit_timer_max = 15;
is_melee_attacking = false;
is_shooting = false;
closest_target = noone;  // Add these two variables
closest_distance = 0;    // so child objects can access them
distance_to_player = 0;  // Add this new instance variable