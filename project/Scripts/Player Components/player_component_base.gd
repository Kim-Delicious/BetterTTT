class_name PlayerComponent

extends Node

@export var max_count: int = 1:
	set(amount):
		max_count = clamp(amount, 1, 9)
	get:
		return max_count
		
var count:
	set(amount):
		count = clamp(amount, 0, max_count)
	get:
		return count

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
