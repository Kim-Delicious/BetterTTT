extends VBoxContainer





func _on_button_pressed() -> void:
	visible = !visible


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
