extends CustomTileComponent


const CHAIN = preload("res://Resources/Material/tile_chained.tres")

func _ready() -> void:
	
	change_texture()
	
func on_action(callable_action: Callable, _action_arguments) -> void:
	
	if callable_action.get_method() == "move_column" || callable_action.get_method() == "move_row":

		tile.animation_player.play("ReflectBullet")
		interacted.emit()
	
func change_texture() -> void:
	var mesh_3d: MeshInstance3D = tile.mesh_instance_3d

	mesh_3d.material_overlay = CHAIN
