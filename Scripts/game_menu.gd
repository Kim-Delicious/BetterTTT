extends VBoxContainer

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _input(event: InputEvent) -> void:
	
	if(event.is_action_pressed("Pause")):
		open_close_menu()
	
func open_close_menu() -> void:
	
	if get_parent().visible:
		animation_player.play("Close")
		get_tree().paused = false
	else:
		animation_player.play("Open")
		get_tree().paused = true

func _on_button_pressed() -> void:
	open_close_menu()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
