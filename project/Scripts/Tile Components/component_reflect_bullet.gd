extends CustomTileComponent


const TILE_CHROME = preload("res://Resources/Material/tile_chrome.tres")

func _ready() -> void:
	var mesh_3d: MeshInstance3D = tile.mesh_instance_3d
	
	mesh_3d.material_overlay = TILE_CHROME

	
func on_action(callable_action: Callable, _action_arguments) -> void:
	
	if callable_action.get_method() == "shoot_tile":

		tile.animation_player.play("ReflectBullet")
		interacted.emit()
	
