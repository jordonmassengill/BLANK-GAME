// Step Event for obj_Orchyde_melee_hitbox
if (!instance_exists(creator)) {
    instance_destroy();
    exit;
}

life_time--;
if (life_time <= 0) {
    instance_destroy();
    exit;
}