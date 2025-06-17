with(all) {
    // NEW, SAFER CHECK:
    // Only run on instances that have a 'creature' struct,
    // AND that struct also has an 'xsp' variable inside it.
    if (variable_instance_exists(id, "creature") && variable_struct_exists(creature, "xsp")) {
        x += creature.xsp;
        y += creature.ysp;
    }
}