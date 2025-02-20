// obj_bomb Alarm 0 Event
var explosion = instance_create_layer(x, y, "Instances", obj_explosion);
explosion.creator = projectile.shooter;
explosion.sprite_index = sExplode;
explosion.image_speed = 1;
has_exploded = true;  // Set flag before destroying
instance_destroy();