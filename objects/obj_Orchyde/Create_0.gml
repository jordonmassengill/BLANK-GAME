// obj_Orchyde Create Event (parent = obj_enemy_parent)
event_inherited();
creature = create_orchyde_properties();

// Add health component
add_component(entity, "health", create_health_component(400)); // Base health for Orchyde

// Set health properties
entity.health.max_health = 400; 
entity.health.current_health = 400;

// Weapon Component to Orchyde ---
var weapon_comp = create_weapon_component(entity);
// Use pickup_weapon instead of add_weapon
var weapon_data = { base_cooldown: 120, pickup_obj_index: undefined };
weapon_comp.pickup_weapon("shotgun", weapon_data); 
add_component(entity, "weapon", weapon_comp);

// Movement and patrol properties
patrol_point_left = x - 100;    
patrol_point_right = x + 100;   
is_patrolling = true;           
moving_right = true;
edge_check_dist = 32;
walk_speed = 1;  // Added this

// Combat properties
melee_cooldown = 0;
melee_cooldown_max = 60;
melee_range = 56;
melee_damage = 10;
hit_timer = 0;
hit_timer_max = 15;
is_melee_attacking = false;
is_shooting = false;

// Add hit function
hit = function() {
    if (hit_timer <= 0) {
        hit_timer = hit_timer_max;
        sprite_index = sOrchydeHit;
        image_index = 0;
        image_speed = 1;
        creature.input.left = false;
        creature.input.right = false;
    }
}