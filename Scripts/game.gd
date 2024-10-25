extends Node3D

@onready var animation_timer: Timer = $AnimationTimer
@onready var grid: Node3D = $Grid

@onready var players: Node = $Players
@onready var turn_ui = $GameUI/TurnUI

@onready var end_animation_player: AnimationPlayer = $GameUI/Control/AnimationPlayer

var max_turns
var current_turn = 0

var end_game := false
var _start_game := true
signal on_end_turn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for setup in GlobalGame.ready_players:
		add_player(setup.character, setup.main_sticker, setup.abilities)
		#print("Setup Player: " + str(players.get_child_count()) )
		
	call_deferred("setup_game")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	pass
	
	
	
func _input(event: InputEvent) -> void:
	
	
	
	if(event.is_action_pressed("NextTurn")):
		end_turn_alt()
	
	
func setup_game() -> void:
	max_turns = players.get_child_count()
		
	turn_ui.setup_uis()
	call_deferred("connect_players_signals")
	call_deferred("connect_players_uis_signals")
	call_deferred("connect_tile_signals")
	call_deferred("_assign_players_ids")
	
	
func add_player(character, main_sticker, abilities) -> void:
	
	var new_player = preload("res://Scenes/player.tscn").instantiate()

	
	# Character
	new_player.character = get_character_sprite_frames_from_id(character)
	
	# main_sticker
	
	new_player.add_child(get_main_sticker_from_id(main_sticker) )
	
	# Abilities
	
	for sticker in abilities:
		var component = get_player_component(sticker)
		new_player.add_child(component)
		
	players.add_child(new_player)
	
func get_player_component(component_id) -> Node:
	
	match component_id:
		# telerow
		0:
			return preload("res://Scenes/Player Components/component_telekenesis_row.tscn").instantiate()

		# telecolumn
		1:
			return preload("res://Scenes/Player Components/component_telekenesis_column.tscn").instantiate()

		# sniper	
		2:
			return preload("res://Scenes/Player Components/component_sniper_gun.tscn").instantiate()


		_:
			return null
		
func get_character_sprite_frames_from_id(character_id) -> SpriteFrames:
	
	match character_id:
		
		# Wizard
		0:
			return preload("res://Textures/SpriteFrames/Wizard_Frames.tres")
			
		#Sharpshooter
		1:
			return preload("res://Textures/SpriteFrames/Sharpshooter_Frames.tres")
			
		_:
			return null
	
func get_main_sticker_from_id(sticker_id) -> Node:
	
	var component = preload("res://Scenes/Player Components/component_symbol.tscn").instantiate()

	component.symbol_type = sticker_id
	
	return component

	
	
	
func connect_players_signals() -> void:
	
	for player in players.get_children():
		if not player.out_of_resources.is_connected(_on_end_turn):
			player.out_of_resources.connect(_on_end_turn)

func connect_players_uis_signals() -> void:
	
	
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
		grid.on_end_round()
		
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

	var label =$GameUI/Control/MatchEnd.winner_label 
	label.text = "Player " + str(player_index + 1) + " Won!"
	
	end_animation_player.play("EndGame")


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
	
