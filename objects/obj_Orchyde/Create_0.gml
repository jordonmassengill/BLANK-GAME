// obj_Orchyde Create Event
creature = create_orchyde_properties();
patrol_point_left = x - 100;    
patrol_point_right = x + 100;   
is_patrolling = true;           
moving_right = true;            
is_shooting = false;
is_melee_attacking = false;
hit_timer = 0;
hit_timer_max = 15;
melee_cooldown = 0;
melee_cooldown_max = 60;  // 1 second cooldown
melee_range = 60;  // Range to trigger melee attack
melee_damage = 10;  // Base melee damage

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
