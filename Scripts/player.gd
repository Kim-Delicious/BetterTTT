extends Node3D


var primary_actions = 1
var secondary_actions = 0

var component_index = 0

var on_turn = false
var id = -1

signal out_of_resources

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func refresh_components() -> void:
	for component in get_children():
		component.refresh()
		
func use_component(on_which_tile) -> void:
	
	if(component_index < 0):
		return
		
	if(get_child_count() <= 0 ):
		out_of_resources.emit() 
		return
	
	var component = get_child(component_index)
	
	component.take_action(self, on_which_tile)
	
		
func select_first_available_component() -> void:
	
	for i in range(get_child_count()):
		var component = get_child(i)
		
		if(!component.available):
			continue
			
		component_index = i
		return
			
	component_index = 0
	out_of_resources.emit() 


	
	
	
