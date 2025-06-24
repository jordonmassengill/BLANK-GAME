// In scr_status_definitions.gml

/// @description Defines all status effect blueprints for the game.

// Using an enum gives us clean, auto-completing names for our effects.
enum EStatus {
    Burn,
    Poison
    // We will add Freeze, etc. here later
}

// This global struct will hold all of our blueprints.
global.StatusDefinitions = {};

// --- Blueprint for Burn ---
// This defines what a "Burn" is.
global.StatusDefinitions[EStatus.Burn] = {
    id: EStatus.Burn,
    name: "Burn",
    duration: 180, // Lasts 3 seconds at 60fps
    tick_rate: 30,  // "Ticks" every 0.5 seconds
    max_stacks: 3,  // Can stack up to 3 times

    // This list defines what the effect actually DOES.
    modifiers: [
        {
            type: "periodic_damage",      // This modifier deals damage over time.
            value: 5,                     // It deals 5 base damage per tick.
            damage_type: DAMAGE_TYPE.DOT, // It is classified as a DOT...
            element: ELEMENT_TYPE.FIRE    // ...and its element is FIRE.
        }
    ]
};

// --- Blueprint for Poison ---
// This defines what a "Poison" is.
global.StatusDefinitions[EStatus.Poison] = {
    id: EStatus.Poison,
    name: "Poison",
    duration: 600, // Lasts 10 seconds
    tick_rate: 60,  // "Ticks" every 1 second
    max_stacks: 1,  // Does not stack, just refreshes duration

    modifiers: [
        {
            type: "periodic_damage",
            value: 8,                     // It deals 8 base damage per tick.
            damage_type: DAMAGE_TYPE.DOT, // It is a DOT...
            element: ELEMENT_TYPE.POISON  // ...and its element is POISON.
        }
    ]
};