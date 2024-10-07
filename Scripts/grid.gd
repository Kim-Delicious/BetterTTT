extends Node3D

@onready var animation_timer: Timer = $"../AnimationTimer"

signal tile_clicked

signal game_won

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_grid_to_all_tile_signals()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	pass

	
	
func _is_array_internally_identical(given_array) -> bool:
	
	var type = given_array[0]
	for i in range(given_array.size() ):
		
		if given_array[i] == type:
			type = given_array[i]
			continue
		else:
			return false
		
	return true
	
func check_for_win() -> bool:
	for i in range(get_child_count()):
		
		var row = get_child(i)
		for j in range(row.get_child_count()):
			var tile = row.get_child(j)

			var symbol = tile.symbol
			if symbol.name != "Symbol":
				print("Node has wrong name! Expected: 'Symbol', Actual: " + str(symbol.name) )
				continue
				
			if symbol.symbol_type == -1:
				continue
				
		###Left->Right
			#Are there enough tiles?
			if j + 2 < row.get_child_count():
				#print("checking Left->Right")
				
				var matching = _do_tiles_match(i, 0, 0, j, 1, 2)
				
				if matching:
					game_won.emit(symbol.symbol_type)
					return true

		###Diagonal Left->Right		
				#Enough Rows?
				if i + 2 < get_child_count():
					#print("checking Diagonal Left->Right")
					
					matching = _do_tiles_match(i, 1, 2, j, 1, 2)
					if matching:
						game_won.emit(symbol.symbol_type)
						return true
					
			
		###Top->Bottom
			if i + 2 < get_child_count():
				#print("checking Top->Bottom")
				
				var matching = _do_tiles_match(i, 1, 2, j, 0, 0)
				if matching:
					game_won.emit(symbol.symbol_type)
					return true
	
		###Diagonal Right->Left		
				if j - 2 >= 0:
					#print("checking Diagonal Right->Left")
					
					matching = _do_tiles_match(i, 1, 2, j, -1, -2)
					if matching:
						game_won.emit(symbol.symbol_type)
						return true
	return false
	

func _do_tiles_match(row_index, next_row, last_row, tile_index, next_tile, last_tile) -> bool:	
	var row = get_child(row_index)
	var second_row = get_child(row_index + next_row)
	var third_row = get_child(row_index + last_row)

	var tile_symbol = row.get_child(tile_index).symbol
	var second_tile_symbol = second_row.get_child(tile_index + next_tile).symbol
	var third_tile_symbol = third_row.get_child(tile_index + last_tile).symbol
	
	var next_three = [-1,-1,-1]
	next_three[0] = tile_symbol.symbol_type
	next_three[1] = second_tile_symbol.symbol_type
	next_three[2] = third_tile_symbol.symbol_type
		
	var win = _is_array_internally_identical(next_three)
	
	if win:
		row.get_child(tile_index).animation_player.play("WinningThree")
		second_row.get_child(tile_index + next_tile).animation_player.play("WinningThree")
		third_row.get_child(tile_index + last_tile).animation_player.play("WinningThree")
		return true
			
	return false


func _connect_grid_to_all_tile_signals() -> void:
	
	for row in get_children():
		for tile in row.get_children():
			var button = tile.button_3d
			button.button_pushed.connect(_player_clicked_on_tile.bind(tile))
	
func _player_clicked_on_tile(which_tile) -> void:
	tile_clicked.emit(which_tile)
