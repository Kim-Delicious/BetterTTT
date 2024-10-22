extends Control

@onready var main: VBoxContainer = $MainMenu

@onready var settings: Control = $SettingsMenu
@onready var selection: Control = $SelectionMenu

@onready var player_container: HBoxContainer = $SelectionMenu/PlayerSelection/VBoxContainer/PlayerContainer

var player_num = 2
var map_selection = 0


func _ready() -> void:
	pass

func _set_all_menues_invisible() -> void:
	main.hide()
	settings.hide()
	selection.hide()
	



#region Main

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/tutorial.tscn")


func _on_play_pressed() -> void:
	main.hide()
	selection.show()

func _on_settings_pressed() -> void:
	main.hide()
	settings.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
#endregion

func _on_back_button_pressed() -> void:
	settings.hide()
	selection.hide()
	main.show()
	
func selection_next() -> void:
	selection.get_child(0).hide()
	selection.get_child(1).show()
	pass
	
func selection_back() -> void:
	selection.get_child(0).show()
	selection.get_child(1).hide()
	pass

func _on_final_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/local_game.tscn")
	
	
func pick_map(which_button) -> void:
	map_selection = which_button
	
	var label = $SelectionMenu/MapSelection/MapLabel
	
	match map_selection:
		0:
			label.text = str(map_selection)
		1:
			label.text = str(map_selection)
		2:
			label.text = str(map_selection)
		3:
			label.text = str(map_selection)
		4:
			label.text = str(map_selection)
		5:
			label.text = str(map_selection)
		6:
			label.text = str(map_selection)
		7:
			label.text = str(map_selection)
		8:
			label.text = str(map_selection)
	
func add_player() -> void:
	
	player_num += 1
	
	if player_num > 4:
		player_num = 4
		return
		
		
	var player
	var separator
	
	match player_num:
		
		2:
			player = player_container.get_child(3)
			separator = player_container.get_child(4)
		3:
			player = player_container.get_child(5)
			separator = player_container.get_child(6)
		4:
			player = player_container.get_child(7)
			separator = player_container.get_child(8)
		_:
			return
		

	
	player.show()
	separator.show()
	
	var label = $SelectionMenu/PlayerSelection/VBoxContainer/HBoxContainer/PlayerNumberCounter
	label.text = str(player_num) + "-Player Game"

	
func remove_player() -> void:
	
	
	if player_num <= 1:
		player_num = 1
		return
		
		
	var player
	var separator
	
	match player_num:
		
		2:
			player = player_container.get_child(3)
			separator = player_container.get_child(4)
		3:
			player = player_container.get_child(5)
			separator = player_container.get_child(6)
		4:
			player = player_container.get_child(7)
			separator = player_container.get_child(8)
		_:
			return
			
		
	
	player.hide()
	separator.hide()
	
	player_num -= 1
	
	var label = $SelectionMenu/PlayerSelection/VBoxContainer/HBoxContainer/PlayerNumberCounter
	label.text = str(player_num) + "-Player Game"
	
	
