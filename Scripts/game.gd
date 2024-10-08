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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	players.get_child(0).on_turn = true
	
	max_turns = players.get_child_count()
	
	connect_players_signals()
	connect_tile_signals()
	_assign_players_ids()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	pass
	
func connect_players_signals() -> void:
	
	for player in players.get_children():
		if not player.out_of_resources.is_connected(_on_player_out_of_resources):
			player.out_of_resources.connect(_on_player_out_of_resources)

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
	
	
	turn_text_label.text = "Player " + str(current_turn + 1) + "'s Turn!"
	turn_text_animation_player.play("NextTurn")
	





func _on_player_out_of_resources() -> void:
	players.get_child(current_turn).on_turn = false

	###Workaround, find better way later?
	animation_timer.start()




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
