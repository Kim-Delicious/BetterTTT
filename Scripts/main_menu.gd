extends Node2D

@onready var main_node: Control = $VBoxContainer/Main
@onready var singleplayer_node: Control = $VBoxContainer/Singleplayer
@onready var multiplayer_node: Control = $VBoxContainer/Multiplayer
@onready var settings_node: Control = $VBoxContainer/Settings
@onready var map_maker_node: Control = $VBoxContainer/MapMaker


func _set_all_menues_invisible() -> void:
	for menu in get_child(0).get_children():
		menu.visible = false


#region Main
func _on_single_player_pressed() -> void:
	_set_all_menues_invisible()
	singleplayer_node.visible = true



func _on_multiplayer_pressed() -> void:
	_set_all_menues_invisible()
	multiplayer_node.visible = true

func _on_mapmaker_pressed() -> void:
	_set_all_menues_invisible()
	map_maker_node.visible = true

func _on_settings_pressed() -> void:
	_set_all_menues_invisible()
	settings_node.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
#endregion

#region Singleplayer

func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_new_pressed() -> void:
	pass # Replace with function body.


func _on_load_pressed() -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	_set_all_menues_invisible()
	main_node.visible = true

#endregion

#region MapMaker
func _on_open_map_pressed() -> void:
	pass # Replace with function body.


func _on_new_map_pressed() -> void:
	pass # Replace with function body.
#endregion
#region Multiplayer

func _on_online_pressed() -> void:
	pass # Replace with function body.


func _on_local_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/local_game.tscn")
#endregion


#region Settings

#endregion
