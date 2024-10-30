extends CustomTileComponent

func _ready() -> void:
	#var mesh_3d: MeshInstance3D = tile.mesh_instance_3d
	#
	#var chrome_mat = preload("res://Resources/Material/tile_sand_chrome.tres")
	#
	#mesh_3d.mesh.surface_set_material(0, chrome_mat)
	pass
	
func on_action(callable_action: Callable, _action_arguments) -> void:
	
	if callable_action.get_method() == "shoot_tile":

		tile.animation_player.play("ReflectBullet")
		interacted.emit()
	
