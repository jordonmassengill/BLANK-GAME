// Create Event of obj_weapon_system
function shoot_projectile(config) {
    var shooter = config.shooter;
    var projectile_obj = config.projectile_obj;
    var aim_angle = config.aim_angle;
    var cooldown_var = config.cooldown_var;
    var base_cooldown = config.base_cooldown;
    
    // Handle optional parameters with proper GML syntax
    var vertical_offset = 0;
    if (variable_struct_exists(config, "vertical_offset")) {
        vertical_offset = config.vertical_offset;
    }
    
    var requirements = [];
    if (variable_struct_exists(config, "requirements")) {
        requirements = config.requirements;
    }
    
    // New shotgun parameters
    var num_pellets = 1;
    if (variable_struct_exists(config, "num_pellets")) {
        num_pellets = config.num_pellets;
    }
    
    var spread_angle = 0;
    if (variable_struct_exists(config, "spread_angle")) {
        spread_angle = config.spread_angle;
    }
    
    // Check requirements
    for (var i = 0; i < array_length(requirements); i++) {
        var req = requirements[i];
        if (!variable_struct_exists(shooter.creature, req) || !shooter.creature[$ req]) {
            return false;
        }
    }
    
    // Check cooldown
    if (shooter.creature[$ cooldown_var] > 0) {
        return false;
    }
    
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
        
        // Set up projectile
        proj.projectile.apply_shooter_stats(shooter);
        proj.direction = final_angle;
        proj.image_angle = final_angle;
        proj.image_yscale = (proj.direction > 89 && proj.direction < 271) ? -1 : 1;
    }
    
    // Apply cooldown
    shooter.creature[$ cooldown_var] = base_cooldown / shooter.creature.stats.get_rate_of_fire();
    
    return true;
}

function shoot_fireball(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_fireball,
        aim_angle: aim_angle,
        cooldown_var: "fireball_cooldown",
        base_cooldown: 15,
        requirements: ["has_fireball", "can_shoot_fireball"]
    });
}

function shoot_dart(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_dart,
        aim_angle: aim_angle,
        cooldown_var: "dart_cooldown",
        base_cooldown: 100,
        requirements: ["has_dart", "can_shoot_dart"]
    });
}

function shoot_waterball(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_waterball,
        aim_angle: aim_angle,
        cooldown_var: "waterball_cooldown",
        base_cooldown: 100,
        requirements: ["has_waterball", "can_shoot_waterball"]
    });
}

function shoot_iceball(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_iceball,
        aim_angle: aim_angle,
        cooldown_var: "iceball_cooldown",
        base_cooldown: 100,
        requirements: ["has_iceball", "can_shoot_iceball"]
    });
}

function shoot_electro(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_electro,
        aim_angle: aim_angle,
        cooldown_var: "electro_cooldown",
        base_cooldown: 20,
        requirements: ["has_electro", "can_shoot_electro"]
    });
}

function shoot_ghoststrike(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_ghoststrike,
        aim_angle: aim_angle,
        cooldown_var: "ghoststrike_cooldown",
        base_cooldown: 10,
        requirements: ["has_ghoststrike", "can_shoot_ghoststrike"]
    });
}

function shoot_ghostball(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_ghostball,
        aim_angle: aim_angle,
        cooldown_var: "ghostball_cooldown",
        base_cooldown: shooter.creature.ghostball_cooldown_max,
        vertical_offset: -16,
        requirements: ["can_shoot_ghostball"]
    });
}

// In obj_weapon_system
function shoot_shotgun(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_shotgun_pellet,
        aim_angle: aim_angle,
        cooldown_var: "shotgun_cooldown",
        base_cooldown: shooter.creature.shotgun_cooldown_max, // Use the max from creature properties
        num_pellets: 5,
        spread_angle: 30,
        requirements: ["has_shotgun", "can_shoot_shotgun"]
    });
}

function shoot_bomb(shooter, aim_angle) {
    return shoot_projectile({
        shooter: shooter,
        projectile_obj: obj_bomb,
        aim_angle: aim_angle,
        cooldown_var: "bomb_cooldown",
        base_cooldown: 120,  // 2 second cooldown
        requirements: ["has_bomb", "can_throw_bomb"]
    });
}