// scr_creature_properties
function create_creature_properties() {
    var props = {
        // Movement properties
        xsp : 0,
        ysp : 0,
        facing_direction : "right",
        state : PlayerState.NORMAL,
        jump_squat_timer : 0,
        jump_timer : 0,
        jump_released : false,
        
        // Ability properties
        has_jetpack : false,
        jetpack_fuel : 0,
        has_fireball : false,
        can_shoot_fireball : false,
        fireball_cooldown : 0,
		// Add bomb properties
		has_bomb : false,
		can_throw_bomb : false,
		bomb_cooldown : 0,
        
        // Input properties (useful for both AI and player control)
        input : {},
		
		// Stats
        stats : create_stats(),
		status_manager: create_status_manager(),  // New status system
        
        // Base properties
        can_die : true,
        
        // Add draw_health_bar as a property function
	draw_health_bar : function(instance_id) {
   var health_width = 40;
   var health_height = 4;
   var health_y_offset = -instance_id.sprite_height + 3;
   
   var xx = instance_id.x - health_width/2;
   var yy = instance_id.y + health_y_offset;
   
   // Draw background (empty health bar)
   draw_set_color(c_red);
   draw_rectangle(xx, yy, xx + health_width, yy + health_height, false);
   
   // Draw current health
   var health_percent = current_health / max_health;
   draw_set_color(c_lime);
   draw_rectangle(xx, yy, xx + (health_width * health_percent), yy + health_height, false);
   
   // Draw tick marks for every 50 health
   draw_set_color(c_black);
   for(var i = 50; i < max_health; i += 50) {
       var tick_x = xx + (health_width * (i/max_health));
       draw_line(tick_x, yy, tick_x, yy + health_height);
   }
   
   // Draw border
   draw_set_color(c_black);
   draw_rectangle(xx, yy, xx + health_width, yy + health_height, true);
   // Define border thickness
var border_thickness = 3; // Adjust this for desired thickness
   
   // Reset draw color
   draw_set_color(c_white);
}
	};
    
    // Setup input properties
props.input = {};
props.input.left = false;
props.input.right = false;
props.input.jump = false;
props.input.fire = false;
props.input.alt_fire = false;  // For bombs/secondary weapons
props.input.aim_x = 0;
props.input.aim_y = 0;
props.input.target_x = 0;
props.input.target_y = 0;
props.input.using_controller = false;
props.input.pause_pressed = false;    // Add these new input properties
props.input.menu_up = false;
props.input.menu_down = false;
props.input.menu_select = false;
props.input.menu_back = false;
    
    return props;
}