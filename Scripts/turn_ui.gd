extends Control

@onready var players: Node = $"../../Players"

signal loaded_player_uis

var loaded = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_player_uis()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if loaded:
		update_sticker_counts()


func load_player_uis() -> void:
	for i in range(players.get_child_count()):
		var player_number = str(i + 1)
		var path = "res://Scenes/UI/player_" + player_number +"_ui.tscn"
		
		var ui = load(path).instantiate()
		
		add_child(ui)
		
	
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
		
func change_ability_symbol_indicators() -> void:
	for i in range(players.get_child_count()):
		var player = players.get_child(i)
		var texture = player.get_child(0).sticker
		
		var player_ui = get_child(i)
		
		for j in range(1, player.get_child_count()): #all except the first
			var component = player.get_child(j)
			
			player_ui.set_ability_sticker_texture(j, component.sticker)
		


func _on_loaded_player_uis() -> void:
	change_player_symbol_indicators()
	change_ability_symbol_indicators()
	loaded = true
	
