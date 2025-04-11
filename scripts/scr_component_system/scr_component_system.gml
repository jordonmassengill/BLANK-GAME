// scr_component_system.gml
// Minimal component system implementation

/// @function add_component(entity, component_name, component)
/// @description Adds a component to an entity and sets up shortcut references
/// @param {struct} entity - The entity to add the component to
/// @param {string} component_name - The name to give this component
/// @param {struct} component - The component to add
/// @returns {struct} The modified entity for method chaining
function add_component(entity, component_name, component) {
    // Initialize components container if it doesn't exist
    if (!variable_struct_exists(entity, "components")) {
        entity.components = {};
        
        // Simple has_component check
        entity.has_component = function(name) {
            return variable_struct_exists(components, name);
        };
    }
    
    // Store component in components struct
    entity.components[$ component_name] = component;
    
    // Store direct reference for convenience
    entity[$ component_name] = component;
    
    // Initialize the component with a reference to its owner if it has an init method
    if (variable_struct_exists(component, "init")) {
        component.init(entity);
    }
    
    return entity; // For method chaining
}