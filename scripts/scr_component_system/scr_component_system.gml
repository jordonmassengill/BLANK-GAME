/// @function add_component(entity, component_name, component)
/// @description Adds a component to an entity and sets up shortcut references.
/// @param {struct} entity The entity to add the component to.
/// @param {string} component_name The name to give this component (e.g., "health").
/// @param {struct} component The component struct to add.
/// @returns {struct} The modified entity for method chaining.
function add_component(entity, component_name, component) {
    // Initialize the 'components' container struct if it doesn't already exist.
    // This block only runs the very first time a component is added to this entity.
    if (!variable_struct_exists(entity, "components")) {
        entity.components = {};

        // Also attach the helper method 'has_component' to the entity itself.
        // This lets us easily check for components later, e.g., entity.has_component("health").
        entity.has_component = function(name) {
            // First, a safety check to see if the 'components' struct exists at all.
            if (!variable_struct_exists(self, "components")) {
                return false;
            }
            // If it does, then check if the specific component key (e.g., "health") exists within it.
            return variable_struct_exists(self.components, name);
        };
    }

    // Add the new component to the 'components' container using its name as the key.
    entity.components[$ component_name] = component;

    // Also add a direct shortcut to the entity for easier access (e.g., entity.health).
    entity[$ component_name] = component;

    // If the component has its own 'init' method, call it now and pass it a
    // reference to its owner entity.
    if (variable_struct_exists(component, "init")) {
        component.init(entity);
    }

    // Return the entity so that calls can be chained if desired.
    return entity;
}