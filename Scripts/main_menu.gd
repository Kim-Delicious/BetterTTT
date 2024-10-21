extends Control

@onready var main: VBoxContainer = $MainMenu

@onready var settings: Control = $SettingsMenu
@onready var selection: Control = $SelectionMenu


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
