// Create Event of obj_weapon_system
// REVISED shoot_projectile function
function shoot_projectile(config) {
    var shooter = config.shooter;
    var projectile_obj = config.projectile_obj;
    var aim_angle = config.aim_angle;
    
    // Handle optional parameters
    var vertical_offset = variable_struct_exists(config, "vertical_offset") ? config.vertical_offset : 0;
    var num_pellets = variable_struct_exists(config, "num_pellets") ? config.num_pellets : 1;
    var spread_angle = variable_struct_exists(config, "spread_angle") ? config.spread_angle : 0;
    
    // Calculate spawn position
    var spawn_distance = 12;
    var offset_x = lengthdir_x(spawn_distance, aim_angle);
    var offset_y = lengthdir_y(spawn_distance, aim_angle) + vertical_offset;
    
    if (aim_angle == 0 || aim_angle == 180) offset_y = vertical_offset;
    
    // Create projectiles
    repeat(num_pellets) {
        var final_angle = aim_angle;
        if (spread_angle > 0) {
            final_angle += random_range(-spread_angle/2, spread_angle/2);
        }
        
        var proj = instance_create_layer(
            shooter.x + offset_x,
            shooter.y + offset_y,
            "Instances",
            projectile_obj
        );
        
        proj.projectile.apply_shooter_stats(shooter);
        proj.direction = final_angle;
        proj.image_angle = final_angle;
        proj.image_yscale = (proj.direction > 89 && proj.direction < 271) ? -1 : 1;
    }
    
    return true; // Always return true on success
}

function shoot_fireball(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_fireball,
        aim_angle: aim_angle,
        cooldown_var: "fireball_cooldown",
        base_cooldown: 15
    });
}

function shoot_dart(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_dart,
        aim_angle: aim_angle,
        cooldown_var: "dart_cooldown",
        base_cooldown: 100,
    });
}

function shoot_waterball(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_waterball,
        aim_angle: aim_angle,
        cooldown_var: "waterball_cooldown",
        base_cooldown: 100,
    });
}

function shoot_iceball(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_iceball,
        aim_angle: aim_angle,
        cooldown_var: "iceball_cooldown",
        base_cooldown: 100,
    });
}

function shoot_electro(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_electro,
        aim_angle: aim_angle,
        cooldown_var: "electro_cooldown",
        base_cooldown: 20,
    });
}

function shoot_ghoststrike(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_ghoststrike,
        aim_angle: aim_angle,
        cooldown_var: "ghoststrike_cooldown",
        base_cooldown: 10,
    });
}

// NEW shoot_ghostball
function shoot_ghostball(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_ghostball,
        aim_angle: aim_angle,
        // The cooldown_var is no longer used by the new component, but we can leave it
        cooldown_var: "ghostball_cooldown", 
        base_cooldown: 300, // <-- 5 seconds, hardcoded
        vertical_offset: -16,
    });
}

// NEW shoot_shotgun
function shoot_shotgun(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_shotgun_pellet,
        aim_angle: aim_angle,
        cooldown_var: "shotgun_cooldown",
        base_cooldown: 120, // <-- 2 seconds, hardcoded
        num_pellets: 5,
        spread_angle: 30,
    });
}

function shoot_bomb(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_bomb,
        aim_angle: aim_angle,
        cooldown_var: "bomb_cooldown",
        base_cooldown: 120,  // 2 second cooldown
    });
}