class_name CustomTileComponent

extends Node


@onready var tile: Node3D = $"../../"



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



func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass
	
	
func refresh() -> void:
	pass
	
func on_action(_callable_action: Callable, _action_arguments) -> void:
	pass

func on_round_end() -> void:
	pass
