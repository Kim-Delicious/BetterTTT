extends PlayerComponent



func _ready() -> void:
	refresh()
	
func refresh() -> void:
	count = max_count
	available = true


func take_action(source_node, on_which_tile) -> void:
	if count <= 0:
		return
	if not on_which_tile.visible:
		return
		
	if on_which_tile.symbol.symbol_type == -1:
		
		decrement()
		stick_symbol_on_tile(source_node.id, on_which_tile)

func stick_symbol_on_tile(player_id, which_tile) -> void:
	if which_tile.can_place:
		which_tile.symbol.change_symbol(player_id)
		which_tile.play_animation("AddSticker")

func decrement(amount = 1) -> void:
	count -= amount
	
	if count <= 0:
		count = 0
		available = false
				
