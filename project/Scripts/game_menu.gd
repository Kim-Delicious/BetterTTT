extends HBoxContainer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var settings: VBoxContainer = $Settings
@onready var last_separator: VSeparator = $VSeparator4

@onready var zoom_slider: VSlider = $Settings/SettingsMenu/VBoxContainer/Menu/Gameplay/Zoom/VSlider
@onready var camera_height_slider: VSlider = $Settings/SettingsMenu/VBoxContainer/Menu/Gameplay/CameraHeight/VSlider


func _ready() -> void:
	zoom_slider.value = GlobalSettings.camera_zoom
	camera_height_slider.value = GlobalSettings.camera_height

func _input(event: InputEvent) -> void:
	
	if(event.is_action_pressed("Pause")):
		open_close_menu()
	
func open_close_menu() -> void:
	var local_game = $"../../.."
	if local_game._start_game:
		return
	
	if visible:
		#animation_player.play("Close")
		visible = false
		settings.visible = false
		last_separator.visible = false
		get_tree().paused = false
	else:
		animation_player.play("Open")
		get_tree().paused = true

func _on_button_pressed() -> void:
	open_close_menu()

func _on_resume_pressed() -> void:
	open_close_menu()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")


func _on_settings_pressed() -> void:
	settings.visible = !settings.visible
	last_separator.visible = !last_separator.visible
	
	pass # Replace with function body.



func _on_zoom_slider_value_changed(value: float) -> void:
	GlobalSettings.change_camera_zoom(value)


func _on_height_slider_value_changed(value: float) -> void:
	GlobalSettings.change_camera_height(value)


func _on_music_slider_value_changed(value: float) -> void:
	GlobalSettings.change_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	GlobalSettings.change_sfx_volume(value)
