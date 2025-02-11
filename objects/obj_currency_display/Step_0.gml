// obj_currency_display Step Event
if (flash_alpha > 0) {
    flash_alpha = max(0, flash_alpha - (1/flash_duration));
}