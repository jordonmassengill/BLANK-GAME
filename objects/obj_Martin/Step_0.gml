// obj_Martin Step Event - REFACTORED
event_inherited();

// If the shop is open, we stop all other logic.
if (shop_menu[? "active"]) {
    var player = instance_find(obj_player_creature_parent, 0);
    if (player != noone) {
        shop_menu_update(shop_menu, shop, player);
    }
    // Exit early so Martin doesn't walk away while shopping
    exit;
}

// --- NEW: Component-driven logic ---
// The AI component decides what to do (e.g., sets input.left = true)
entity.ai.update();
// The Movement component reads the AI's input and handles all physics
entity.movement.update();

// Copy the final, collision-adjusted speeds to the creature struct
// so obj_movement_system can apply them to the instance's x/y coordinates.
creature.xsp = entity.movement.xsp;
creature.ysp = entity.movement.ysp;
// --- End Component-driven logic ---

// Update his facing direction based on his actual movement
if (creature.xsp > 0) creature.facing_direction = "right";
if (creature.xsp < 0) creature.facing_direction = "left";

// --- Player Interaction Logic (this part is mostly unchanged) ---
var player = instance_place(x, y - 1, obj_player_creature_parent);
if (player != noone) {
    var platform_center = x;
    var player_center = player.x;
    var center_threshold = 32;

    if (abs(platform_center - player_center) <= center_threshold) {
        if (player.creature.input.interact) {
            shop_menu[? "active"] = true;
            shop_menu[? "selected_item"] = 0;
            instance_deactivate_all(true);
            instance_activate_object(obj_Martin);
            instance_activate_object(obj_input_manager);
            instance_activate_object(player);
        }
    }
}