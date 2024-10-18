extends Node3D


@onready var grid: Node3D = $Grid

@onready var players: Node = $Players

@onready var turn_text_animation_player: AnimationPlayer = $GameUI/Control/Game/AnimationPlayer
@onready var turn_text_label: Label = $GameUI/Control/Game/TurnLabel

@onready var game_win_label: Label = $GameUI/Control/Game/MatchEnd/EndLabel

@onready var animation_timer: Timer = $AnimationTimer


var max_turns
var current_turn = 0

var end_game := false
var _start_game := true
signal on_end_turn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	max_turns = players.get_child_count()
	
	connect_players_signals()
	connect_players_uis_signals()
	connect_tile_signals()
	_assign_players_ids()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	pass
	
	
	
func _input(event: InputEvent) -> void:
	
	
	
	if(event.is_action_pressed("NextTurn")):
		end_turn_alt()
	
	
	
	
func connect_players_signals() -> void:
	
	for player in players.get_children():
		if not player.out_of_resources.is_connected(_on_end_turn):
			player.out_of_resources.connect(_on_end_turn)

func connect_players_uis_signals() -> void:
	

	var game_ui = find_child("GameUI")
	var turn_ui = game_ui.get_child(1)
	
	for player_ui in turn_ui.get_children():
		
		var player_index = player_ui.get_index()
		var player = players.get_child(player_index)
		
		var symbol = player_ui.player_symbol
		
		if not symbol.pushed_on.is_connected(player.select_clicked_component):
			symbol.pushed_on.connect(player.select_clicked_component)
			
		
		for i in range(1, player_ui.inventory.get_child_count() - 1):
			var sticker = player_ui.inventory.get_child(i).get_child(0)
			if not sticker.pushed_on.is_connected(player.select_clicked_component):
				
				
				sticker.pushed_on.connect(player.select_clicked_component)
			


func connect_tile_signals() -> void:
	
	for row in grid.get_children():
		for tile in row.get_children():
			
			if not tile.symbol.mid_tile_place.is_connected(grid.check_for_win):
				tile.symbol.mid_tile_place.connect(grid.check_for_win)
		
func _assign_players_ids() -> void:
	
	for i in range(players.get_child_count()):
		var player = players.get_child(i)
		player.id = i
	
func _next_turn() -> void:
	
	if end_game:
		return
		
	
	current_turn += 1
	
	if current_turn >= max_turns:
		current_turn = 0
		
	players.get_child(current_turn).on_turn = true
	players.get_child(current_turn).refresh_components()


func _on_end_turn(which_player) -> void:
	which_player.on_turn = false

	###Workaround, find better way later?
	animation_timer.start()
	
func end_turn_alt() -> void:

	var which_player = players.get_child(current_turn)
	which_player.on_turn = false

	###Workaround, find better way later?
	animation_timer.start()
	
	on_end_turn.emit(players.get_child(current_turn))



func _on_grid_tile_clicked(which_tile) -> void:
	if end_game:
		return
		
	var player = players.get_child(current_turn)
		
	player.use_component(which_tile)
	player.select_first_available_component()	
	
func _on_animation_timer_timeout() -> void:
	_next_turn()
	
	
func _on_panic_time(tile_array: Array) -> void:
		
	#for i in range(players.get_child_count() ):
		#players.get_child(i).on_turn = false
		
	for tile in tile_array:
		tile.symbol.animation_player.play("WinningThree")
		
	print("TIME TO PANIC!")


func _on_game_won(tile_array: Array) -> void:
	var player_index = tile_array[0].symbol.symbol_type
	
	end_game = true
	
	for i in range(players.get_child_count() ):
		players.get_child(i).on_turn = false
		
	for tile in tile_array:
		tile.play_animation("WinningThree")

	game_win_label.text = "Player " + str(player_index + 1) + " won!"
	turn_text_animation_player.play("GameWon")


func _on_turn_ui_done_with_anim(anim_name: String) -> void:
	if(anim_name == "BeginGame"):
		get_tree().paused = false
		_start_game = false
		players.process_mode = Node.PROCESS_MODE_INHERIT
		find_child("GameUI").get_child(1).process_mode = Node.PROCESS_MODE_INHERIT
		players.get_child(0).on_turn = true
		
		
		print("Game has finished starting!")


func _on_turn_ui_loaded_player_uis() -> void:
	get_tree().paused = true
	
