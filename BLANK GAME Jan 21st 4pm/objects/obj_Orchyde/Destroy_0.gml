// obj_Orchyde Destroy Event
creature.status_manager.clear_effects();
var death_effect = instance_create_layer(x, y, "Instances", obj_OrchydeDeath);
death_effect.sprite_index = sOrchydeDeath;
death_effect.image_xscale = image_xscale;