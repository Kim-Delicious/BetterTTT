extends PlayerComponent

enum SymbolType {Empty = -1, Circle, Mult, Tri, Diamond}
@export var symbol_type = SymbolType.Empty


func _ready() -> void:
	refresh()
	set_symbol_texture()
	
func refresh() -> void:
	count = max_count
	available = true


func take_action(source_node, on_which_tile) -> void:
	if count <= 0:
		return
	if on_which_tile.visible == false:
		return
		
	if on_which_tile.get_child(0).get_child(0).visible == false: # MeshInstance3D
		return
		
	if on_which_tile.symbol.symbol_type == -1:
		
		decrement()
		on_which_tile.action_on_components(stick_symbol_on_tile, [source_node.id, on_which_tile])
		
	elif symbol_type == -1:
		decrement()
		on_which_tile.action_on_components(stick_symbol_on_tile, [source_node.id, on_which_tile])
		
func stick_symbol_on_tile(player_id, which_tile) -> void:
	if which_tile.can_place:
		which_tile.symbol.change_symbol(symbol_type)
		which_tile.symbol.placed_by_index = player_id
		which_tile.play_animation("AddSticker")
		
		for comp : Node in which_tile.components.get_children():
			if comp.name == "Shootable":
				which_tile.replace_component(comp.get_index(), "reflect_bullet")

func decrement(amount = 1) -> void:
	count -= amount
	
	if count <= 0:
		count = 0
		available = false
		
		
func set_symbol_texture() -> void:
	match symbol_type:
		SymbolType.Circle:
			sticker = preload("res://Textures/Sticker_Circle.png")
			pass
		SymbolType.Mult:
			sticker = preload("res://Textures/Sticker_Mult.png")
			pass
		SymbolType.Tri:
			sticker = preload("res://Textures/Sticker_Tri.png")
			pass
		SymbolType.Diamond:
			sticker = preload("res://Textures/Sticker_Diamond.png")
			pass
		_:
			sticker = null
				
