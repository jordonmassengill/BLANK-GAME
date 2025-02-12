// obj_npc_parent Step Event (parent = obj_creature_parent)
event_inherited();

// Death check
if (creature.current_health <= 0) {
    // Reset any active status effects
    creature.status_manager.clear_effects();
    instance_destroy();
    exit;
}