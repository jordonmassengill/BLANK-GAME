// Create Event of obj_level_setup
function setup_collision_tiles() {
    var layer_id = layer_get_id("Collision");
    
    var map_id = layer_tilemap_get_id(layer_id);
    
    if (map_id == -1) {
        return;
    }
    
    var width = tilemap_get_width(map_id);
    var height = tilemap_get_height(map_id);
    
    var count = 0;
    for(var xx = 0; xx < width; xx++) {
        for(var yy = 0; yy < height; yy++) {
            var tile = tilemap_get(map_id, xx, yy);
            if(tile != 0) {
                var x_pos = xx * tilemap_get_tile_width(map_id);
                var y_pos = yy * tilemap_get_tile_height(map_id);
                // Create the obj_floor in the same Collision layer
                instance_create_layer(x_pos, y_pos, "Collision", obj_floor);
                count++;
            }
        }
    }
}

setup_collision_tiles();