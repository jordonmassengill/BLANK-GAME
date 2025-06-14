// obj_creature_parent Cleanup Event
if (variable_instance_exists(id, "creature") && variable_instance_exists(creature, "status_manager")) {
    creature.status_manager.cleanup();
}