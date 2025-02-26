// scr_state_machine.gml
// Create a robust state machine system

/// @function create_state_machine()
/// @description Creates a new state machine instance
/// @returns {struct} A new state machine
function create_state_machine() {
    return {
        // Core properties
        current_state: "",
        previous_state: "",
        states: {},
        state_time: 0,          // How long we've been in the current state
        global_state: undefined, // Optional state that always executes
        owner: undefined,        // Reference to the owner object/struct
        is_debug_enabled: false, // Whether to log state changes
        
        // Configuration
        init: function(owner_ref) {
            owner = owner_ref;
            return self;
        },
        
        enable_debug: function(enable) {
            is_debug_enabled = enable;
            return self;
        },
        
        set_global_state: function(update_func) {
            global_state = update_func;
            return self;
        },
        
        // State management
        add_state: function(state_name, enter_func = undefined, update_func = undefined, on_leave_func = undefined) {
            states[$ state_name] = {
                name: state_name,
                enter: enter_func ?? function() {},
                update: update_func ?? function() {},
                on_leave: on_leave_func ?? function() {}
            };
            return self;
        },
        
        // State transitions
        change_state: function(new_state_name) {
            // Don't change to the same state
            if (new_state_name == current_state) return self;
            
            // Validate the new state exists
            if (!variable_struct_exists(states, new_state_name)) {
                show_debug_message("ERROR: State '" + new_state_name + "' does not exist!");
                return self;
            }
            
            // Log state change if debugging is enabled
            if (is_debug_enabled) {
                show_debug_message("STATE CHANGE: " + current_state + " -> " + new_state_name);
            }
            
            // Run on_leave on current state
            if (current_state != "" && variable_struct_exists(states, current_state)) {
                states[$ current_state].on_leave();
            }
            
            // Update state tracking
            previous_state = current_state;
            current_state = new_state_name;
            state_time = 0;
            
            // Enter the new state
            states[$ current_state].enter();
            
            return self;
        },
        
        // Return to the previous state
        revert_to_previous: function() {
            if (previous_state != "") {
                return change_state(previous_state);
            }
            return self;
        },
        
        // Main update function to call each frame
        update: function() {
            // Increment state time
            state_time++;
            
            // Execute global state if it exists
            if (global_state != undefined) {
                global_state();
            }
            
            // Execute current state if it exists
            if (current_state != "" && variable_struct_exists(states, current_state)) {
                states[$ current_state].update();
            }
            
            return self;
        },
        
        // Utility functions
        get_current_state: function() {
            return current_state;
        },
        
        get_state_time: function() {
            return state_time;
        },
        
        is_in_state: function(state_name) {
            return current_state == state_name;
        },
        
        has_state: function(state_name) {
            return variable_struct_exists(states, state_name);
        }
    };
}