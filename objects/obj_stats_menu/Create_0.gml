// obj_stats_menu Create Event
stats_menu_active = false;
upgrade_mode = false;
scanline_offset = 0;
points_spent = 0;
selected_stat = 0;

// Stats to display from stats system
stats_list = [
    {name: "Max Health", base: 150, per_level: 50, level: 1, upgradeable_by: "life"},
    {name: "Life Steal", base: 0, per_level: 5, level: 1, upgradeable_by: "life"},
    {name: "Regeneration", base: 0, per_level: 1, level: 1, upgradeable_by: "life"},
    {name: "Physical Damage", base: 1.0, per_level: 1, level: 1, upgradeable_by: "power"},
    {name: "Magical Damage", base: 1.0, per_level: 1, level: 1, upgradeable_by: "power"},
    {name: "Elemental Power", base: 1.0, per_level: 1, level: 1, upgradeable_by: "manifest"},
    {name: "Move Speed", base: 3, per_level: 0.25, level: 1, upgradeable_by: "speed"},
    {name: "Rate of Fire", base: 1.0, per_level: 0.25, level: 1, upgradeable_by: "speed"},
    {name: "Projectile Speed", base: 1.0, per_level: 0.25, level: 1, upgradeable_by: "speed"},
    {name: "Armor", base: 1, per_level: 1, level: 1, upgradeable_by: "defense"},
    {name: "Resistance", base: 1, per_level: 1, level: 1, upgradeable_by: "defense"}
];

upgrade_colors = ds_map_create();
ds_map_add(upgrade_colors, "life", make_color_rgb(255, 50, 50));     // Bright red
ds_map_add(upgrade_colors, "power", make_color_rgb(50, 50, 255));    // Bright blue 
ds_map_add(upgrade_colors, "manifest", make_color_rgb(255, 165, 0)); // Bright orange
ds_map_add(upgrade_colors, "speed", make_color_rgb(50, 255, 50));    // Bright green
ds_map_add(upgrade_colors, "defense", make_color_rgb(200, 50, 255)); // Bright purple