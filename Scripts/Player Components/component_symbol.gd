extends Node


@export var max_count = 1
var count

var available

func _ready() -> void:
	refresh()
	
func refresh() -> void:
	count = max_count
	available = true


func take_action(source_node, on_which_tile) -> void:
	if count <= 0:
		return
		
	if on_which_tile.symbol.symbol_type == -1:
		
		decrement()
		on_which_tile.action_on_tile(source_node.id)

func decrement(amount = 1) -> void:
	count -= amount
	
	if count <= 0:
		count = 0
		available = false
				
