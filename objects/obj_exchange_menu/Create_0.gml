// obj_exchange_menu Create Event
menu_active = false;
selected_orb_type = undefined;
selected_inventory_slots = []; // Initialize as an empty array
cursor_position = "inventory";
selected_item = 0;

// Style variables from first version
glow_alpha = 0.5;
glow_dir = 1;
scanline_offset = 0;
timer = 0;
active_pulse = 0;

// Colors (using make_colour_rgb for GameMaker consistency)
color_primary = make_colour_rgb(0, 255, 255);  // Cyan
color_secondary = make_colour_rgb(255, 0, 255); // Magenta
color_background = make_colour_rgb(0, 10, 20);  // Dark blue
color_highlight = make_colour_rgb(255, 255, 0); // Yellow

// Define valid orb types
valid_types = ["life", "power", "speed", "defense", "manifest", "finesse", "blank"];

// Orb types configuration
orb_types = [
    {name: "LIFE ORB", color: make_colour_rgb(255, 50, 50), type: "life"},      // Bright red
    {name: "POWER ORB", color: make_colour_rgb(50, 50, 255), type: "power"},    // Bright blue
    {name: "SPEED ORB", color: make_colour_rgb(50, 255, 50), type: "speed"},    // Bright green
    {name: "DEFENSE ORB", color: make_colour_rgb(200, 50, 255), type: "defense"},  // Bright purple
    {name: "MANIFEST ORB", color: make_colour_rgb(255, 165, 0), type: "manifest"},  // Bright orange
    {name: "FINESSE ORB", color: make_colour_rgb(139, 69, 19), type: "finesse"}  // Brown
];

// Grid effect setup
grid_size = 1024;
grid_buffer = buffer_create(grid_size, buffer_fixed, 1);
for (var i = 0; i < grid_size; i++) {
    buffer_write(grid_buffer, buffer_u8, irandom_range(48, 90));
}
grid_chars = "";
for (var i = 0; i < 16; i++) {
    grid_chars += chr(irandom_range(48, 90));
}

// Mapping for display slots to inventory slots
display_to_inventory_slot = ds_map_create();