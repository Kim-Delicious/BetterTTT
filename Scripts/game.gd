extends Node3D


@onready var grid: Node3D = $Grid

@onready var players: Node = $Players

@onready var turn_text_animation_player: AnimationPlayer = $VBoxContainer/AnimationPlayer
@onready var turn_text_label: Label = $VBoxContainer/Label

@onready var animation_timer: Timer = $AnimationTimer


var max_turns
var current_turn = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	players.get_child(0).on_turn = true
	
	max_turns = players.get_child_count()
	
	_connect_players_signals()
	_assign_players_ids()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
	
func _connect_players_signals() -> void:
	
	for player in players.get_children():
		player.out_of_resources.connect(_on_player_out_of_resources)
		
func _assign_players_ids() -> void:
	
	for i in range(players.get_child_count()):
		var player = players.get_child(i)
		player.id = i
	
func _next_turn() -> void:
	
	if grid.check_for_win():
		print("THE GAME IS OVER!")
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
	var player = players.get_child(current_turn)
		
	player.use_component(which_tile)
	player.select_first_available_component()
	
	


func _on_animation_timer_timeout() -> void:
	_next_turn()
