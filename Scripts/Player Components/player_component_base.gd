class_name PlayerComponent

extends Node

@export var max_count = 1
var count

var available

const BLANK_STICKER = preload("res://Textures/BlankSticker.png")

@export var sticker = BLANK_STICKER

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass
	
func refresh() -> void:
		pass
		
func take_action(_source_node, _on_which_tile) -> void:
	pass