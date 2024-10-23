extends Control

@onready var players: Node = $"../../Players"

signal loaded_player_uis

var loaded = false

signal done_with_anim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if loaded:
		update_sticker_counts()

func setup_uis() -> void:
	load_player_uis()
	connect_players_signals()


func load_player_uis() -> void:
		
	for i in range(players.get_child_count()):
		
		
		var player_number: String = str(i + 1)
	
		var path = "res://Scenes/UI/player_" + player_number +"_ui.tscn"
		
		var player_ui = load(path).instantiate()
		
		add_child(player_ui)
		
		var player = players.get_child(i)
		for j in range(1, player.get_child_count()): #all except the first
			
			player_ui.add_missing_center_pieces(j, i, player)
			
			
		player_ui.character_sprite.sprite_frames = players.get_child(i).character

		
	
	loaded_player_uis.emit()
	
	
func update_sticker_counts() -> void:
	
	for i in range(players.get_child_count()):
		
		var player = players.get_child(i)	
		var player_ui = get_child(i)
				
		player_ui.update_symbol_text_count(player.get_child(0).count)
		
		for j in range(1, player.get_child_count()): #all except the first
			var component = player.get_child(j)
			
			player_ui.update_ability_text_count(j, component.count)
	
func change_player_symbol_indicators() -> void:
	for i in range(players.get_child_count()):
		var player = players.get_child(i)
		var texture = player.get_child(0).sticker
		
		get_child(i).set_symbol_texture(texture)
		if i == 0 || i == 2:
			get_child(i).player_symbol.get_child(1).play("Unpack")
		else:
			get_child(i).player_symbol.get_child(1).play("UnpackFlipped")
		
func change_ability_symbol_indicators() -> void:
	for i in range(players.get_child_count()):
		var player = players.get_child(i)		
		var player_ui = get_child(i)
		
		for j in range(1, player.get_child_count()): #all except the first
			var component = player.get_child(j)
			
			player_ui.set_ability_sticker_texture(j, component.sticker)
			
			var ability_sticker = player_ui.inventory.get_child(j).get_child(0)
			ability_sticker.get_child(1).play("Unpack")
			
			if i == 0 || i == 2:
				ability_sticker.get_child(1).play("Unpack")
			else:
				ability_sticker.get_child(1).play("UnpackFlipped")
			
			

func _on_loaded_player_uis() -> void:
	change_player_symbol_indicators()
	change_ability_symbol_indicators()
	loaded = true
	
func connect_players_signals() -> void:
	
	for i in range(players.get_child_count()):
		var player = players.get_child(i)
		
		if not player.out_of_resources.is_connected(_on_end_turn):
			player.out_of_resources.connect(_on_end_turn)
			
		var player_ui = get_child(i)
		if not player.select_component.is_connected(player_ui.update_selection_indicator):
			player.select_component.connect(player_ui.update_selection_indicator)
			
		if not player_ui.player_ui_anim_fin.is_connected(on_player_ui_anim_fin):
			player_ui.player_ui_anim_fin.connect(on_player_ui_anim_fin)
	
		
func _on_end_turn(which_player) -> void:
	animate_end_turn(which_player)
	
	
func animate_end_turn(which_player) -> void:
	
	var player_ui = get_child(which_player.id)
	
	player_ui.animation_player.play("EndTurn")
	
	if which_player.component_index == 0:
		player_ui.player_symbol.get_child(1).play("HideIndicator")
	else:
		var current_sticker = player_ui.inventory.get_child(which_player.component_index).get_child(0)
		current_sticker.get_child(1).play("HideIndicator")
	
	var next_player_ui
	if which_player.id >= players.get_child_count() - 1:
		next_player_ui =  get_child(0)
	else:
		next_player_ui = get_child(which_player.id + 1)
		
	next_player_ui.animation_player.play("BeginTurn")
	
func on_player_ui_anim_fin(anim_name: StringName) -> void:
	done_with_anim.emit(anim_name)
	
