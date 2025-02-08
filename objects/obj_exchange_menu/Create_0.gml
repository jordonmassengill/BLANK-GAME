// obj_exchange_menu Create Event
menu_active = false;
selected_orb_type = undefined;  // What type of orb we're changing to
selected_inventory_slots = [];  // Array to store which inventory slots are selected
cursor_position = "inventory";  // Can be "inventory" or "options"
selected_item = 0;

// Define available orb types
orb_types = [
    {name: "Life Orb", color: c_red, type: "life"},
    {name: "Power Orb", color: c_blue, type: "power"},
    {name: "Speed Orb", color: c_green, type: "speed"},
    {name: "Defense Orb", color: c_purple, type: "defense"},
    {name: "Manifest Orb", color: c_orange, type: "manifest"}
];

// Define valid orb types that can be exchanged
valid_types = ["life", "power", "speed", "defense", "manifest", "blank"];

function is_valid_orb(item) {
    return (item != undefined && array_contains(valid_types, item.type));
}

// In obj_exchange_menu Create Event, add:
display_to_inventory_slot = ds_map_create();