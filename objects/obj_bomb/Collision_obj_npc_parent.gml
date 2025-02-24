// obj_bomb Collision Event with obj_npc_parent
if (!has_exploded && !is_exploding) {
    projectile.on_hit(other);  // Do 1 physical damage
    
    // Create explosion directly here instead of using alarm
    var explosion = instance_create_layer(x, y, "Instances", obj_explosion);
    explosion.creator = projectile.shooter;
	explosion.creator_changed();  // Add this line to match alarm behavior
    explosion.sprite_index = sExplode;
    explosion.image_speed = 1;
    
    // Set flags and destroy
    has_exploded = true;
    instance_destroy();
}