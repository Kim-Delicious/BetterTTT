extends Node3D

signal tile_clicked
signal game_won
signal game_tie
signal panic_time

@export_category("Game Options")
@export var tiles_to_panic : int = 3
@export var tiles_to_win : int = 5
@onready var buffer_timer: Timer = $"../BufferTimer"

var component_buffer : Array =  []
var buffer_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_grid_to_all_tile_signals()
	
	tiles_to_win = GlobalGame.tiles_to_win
	tiles_to_panic = GlobalGame.tiles_to_win - 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	pass

	
	
func is_array_internally_identical(given_array: Array) -> bool:
	
	if given_array.size() == 0:
		return false
	
	var type = given_array[0]
	for i in range(given_array.size() ):
		
		if given_array[i] == type:
			type = given_array[i]
			continue
		else:
			return false
		
	return true
	
func check_for_win() -> void:
	
	var free_tiles = 0
	
	for i in range(get_child_count()):
		
		var row = get_child(i)
		for j in range(row.get_child_count()):
			var tile = row.get_child(j)

			var symbol = tile.symbol
			
			if !tile.get_child(0).visible:
				continue
			
			if symbol.name != "Symbol":
				print("Node has wrong name! Expected: 'Symbol', Actual: " + str(symbol.name) )
				continue
				
			if symbol.symbol_type == -1:
				free_tiles += 1
				continue
				

			### Basic Three
			emit_on_tiles_match(i, j, tiles_to_panic, panic_time)
			
			### Instant Win
			emit_on_tiles_match(i, j, tiles_to_win, game_won)
			
	if free_tiles == 0:
		game_tie.emit()
							
	return
	

func emit_on_tiles_match(row_index, tile_index, max_length, the_signal: Signal) -> void:	
		
	do_tiles_match_vertically(row_index, tile_index, max_length, the_signal)
	do_tiles_match_horizontally(row_index, tile_index, max_length, the_signal)
	do_tiles_match_diagonally(row_index, tile_index, max_length, the_signal)
	do_tiles_match_diagonally_bottom_up(row_index, tile_index, max_length, the_signal)		
	
	
func do_tiles_match_vertically(row_index, tile_index, max_length, the_signal: Signal) -> void:
	
	if(row_index + max_length >= get_child_count() + 1):
		return
	
	var symbol_array = []
	var tile_array = []
	
	for i in range(max_length):
		var tile = get_child(row_index + i).get_child(tile_index)
		symbol_array.append(tile.symbol.symbol_type)
		tile_array.append(tile)
		
	if is_array_internally_identical(symbol_array):
		the_signal.emit(tile_array)
	
	
	
func do_tiles_match_horizontally(row_index, tile_index, max_length, the_signal: Signal) -> void:
	
	if(tile_index + max_length >= get_child(row_index).get_child_count() + 1):
		return
	
	var symbol_array = []
	var tile_array : Array = []
	
	for i in range(max_length):
		var tile = get_child(row_index).get_child(tile_index + i)
		symbol_array.append(tile.symbol.symbol_type)
		tile_array.append(tile)
		
	if is_array_internally_identical(symbol_array):
		the_signal.emit(tile_array)
	
	
func do_tiles_match_diagonally(row_index, tile_index, max_length, the_signal: Signal) -> void:
	if(row_index + max_length >= get_child_count() + 1):
		return
		
	if(tile_index + max_length >= get_child(row_index).get_child_count() + 1):
		return
		
	var symbol_array: Array = []
	var tile_array: Array = []
	for i in range(max_length):
		var temp_row = get_child(row_index + i)

				

		for j in range(max_length):
			var tile = temp_row.get_child(tile_index + j)

			if i == j:
				symbol_array.append(tile.symbol.symbol_type)
				tile_array.append(tile)
				
	if is_array_internally_identical(symbol_array):
		the_signal.emit(tile_array)
		

func do_tiles_match_diagonally_bottom_up(row_index, tile_index, max_length, the_signal: Signal) -> void:
	if(row_index - max_length <= -2):
		return
		
	if(tile_index + max_length >= get_child(row_index).get_child_count() + 1):
		return
		
	var symbol_array: Array = []
	var tile_array := []
	for i in range(max_length):
		var row = get_child(row_index - i)

		for j in range(max_length):
			var tile = row.get_child(tile_index + j)

			if j == i:
				symbol_array.append(tile.symbol.symbol_type)
				tile_array.append(tile)

				
	if is_array_internally_identical(symbol_array):
		the_signal.emit(tile_array)
	

func _connect_grid_to_all_tile_signals() -> void:
	
	for row in get_children():
		for tile in row.get_children():
			var button = tile.button_3d
			button.button_pushed.connect(_player_clicked_on_tile.bind(tile))
	
func _player_clicked_on_tile(which_tile) -> void:
	tile_clicked.emit(which_tile)
	
	
func on_end_round() -> void:
	
	for i in range(get_child_count()):
		
		var row = get_child(i)
		for j in range(row.get_child_count()):
			var tile = row.get_child(j)
			
			if !tile.get_child(0).visible:
				continue
			
			if tile.command_buffer.size() <= 0:
				continue
			
			var tile_method: Callable = tile.activate_round_end_components
			
			component_buffer.append(tile_method)
		
	iterate_through_buffer()

func on_end_turn() -> void:
	
	for i in range(get_child_count()):
		
		var row = get_child(i)
		for j in range(row.get_child_count()):
			var tile = row.get_child(j)
			
			tile.refresh_turn_buffer()
			
			if !tile.get_child(0).visible:
				continue
			
			if tile.turn_command_buffer.size() <= 0:
				continue
			
			var tile_method: Callable = tile.activate_turn_end_components
			
			component_buffer.append(tile_method)
		
	iterate_through_buffer()


func apply_chaos() -> void:
	

	
	var possible_components: Array
	
	for packed_scene_name in DirAccess.get_files_at("res://Scenes/Tile Components/"):
		

		if packed_scene_name == "placable" + ".tscn":
			continue
		if packed_scene_name == "shootable" + ".tscn":
			continue
		if packed_scene_name == "movable" + ".tscn":
			continue
			
		possible_components.append(load("res://Scenes/Tile Components/" + packed_scene_name) )
	
	
	
	for i in range(get_child_count()):
		
		var row = get_child(i)
		for j in range(row.get_child_count()):
			var tile = row.get_child(j)
			
			if !tile.get_child(0).visible:
				continue
			
			var random_num = randf_range(0, 1)
			
			if random_num <= GlobalGame.chaos_factor:
				
				#Do randomness
				
				var random_pick = randi_range(0, possible_components.size() - 1)
				
				var new_comp = possible_components[random_pick].instantiate()
				
				tile.components.add_child(new_comp)
								
			tile.ready_tile()

	
	possible_components.clear()

func stop_all_animations() -> void:
	
	for i in range(get_child_count()):
		
		var row = get_child(i)
		for j in range(row.get_child_count()):
			var tile = row.get_child(j)
			
			tile.animation_player.stop()
	

func iterate_through_buffer() -> void:	
	if buffer_index > component_buffer.size() - 1:
		
		component_buffer.clear()
		buffer_index = 0
		
		# Start next round
		
		return
		
	component_buffer[buffer_index].call()
	buffer_timer.start()
	
	buffer_index += 1
	
	


func _on_match_end_screen_landed() -> void:
	stop_all_animations()
