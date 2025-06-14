// Animation End Event
if (sprite_index == sOrchydeMelee) {
    is_melee_attacking = false;
    sprite_index = sOrchydeIdle;
} else if (sprite_index == sOrchydeShoot) {
    is_shooting = false;
    sprite_index = sOrchydeIdle;
}