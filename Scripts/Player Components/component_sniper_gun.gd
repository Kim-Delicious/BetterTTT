extends PlayerComponent




"""Add particle to this object instead of the the tile"""


func _ready() -> void:
	refresh()
	
func refresh() -> void:
	count = max_count
	available = true


func take_action(_source_node, on_which_tile) -> void:
	if count <= 0:
		return
		
	if on_which_tile.visible == false:
		return
		
	if on_which_tile.get_child(0).get_child(0).visible == false: # MeshInstance3D
		return
		
	if on_which_tile.symbol.symbol_type != -1:
		return
		
	decrement()
	on_which_tile.action_on_components(shoot_tile, [on_which_tile])

func shoot_tile(which_tile) -> void:
	which_tile.can_place = false
	which_tile.symbol.change_symbol(-1)
	which_tile.animation_player.play("GetShot")
	which_tile.stop_detecting_mouse()
	
	
func decrement(amount = 1) -> void:
	count -= amount
	
	if count <= 0:
		count = 0
		available = false
		
