extends Node


var camera_zoom = 35
var camera_height = 64

var music_volume = 10
var sfx_volume = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func change_camera_zoom(value: float) -> void:
	camera_zoom = value
	
	
func change_camera_height(value: float) -> void:
	camera_height = value
	
func change_music_volume(value: float) -> void:
	music_volume = value
	
func change_sfx_volume(value: float) -> void:
	sfx_volume = value
