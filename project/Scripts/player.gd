extends Node3D


var character: CompressedTexture2D

var primary_actions = 1
var secondary_actions = 0

var component_index = 0

var on_turn = false
var id = -1

signal out_of_resources
signal select_component

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
		
func refresh_components() -> void:	
	for component in get_children():
		component.refresh()
	component_index = 0
		
func use_component(on_which_tile) -> void:
	if not on_turn:
		return
	
	if(component_index < 0):
		return
		
	if(get_child_count() <= 0 ):
		out_of_resources.emit() 
		return
	
	var component = get_child(component_index)
	
	component.take_action(self, on_which_tile)
	
		
func select_first_available_component() -> void:
	
	if get_child(component_index).count > 0:
		return
		
	
	for i in range(get_child_count()):
		var component = get_child(i)
		
		if(!component.available):
			continue
			
		component_index = i
		select_component.emit(self)
		return
			
	component_index = 0
	select_component.emit(self)
	out_of_resources.emit(self)
	
func select_clicked_component(which_index) -> void:
	
	var component = get_child(which_index)
		
	if(!component.available):
		return
	
	component_index = which_index
	select_component.emit(self)
	


	
	
	
