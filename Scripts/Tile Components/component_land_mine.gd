extends CustomTileComponent



var interactions = 0
var max_interaction = 2

var neighbors: Array

const LAND_MINE = preload("res://Resources/Material/land_mine.tres")
const LAND_MINE_ADJACENT = preload("res://Resources/Material/land_mine_adjacent.tres")



func _ready() -> void:
	available = false
	

	
func after_tile_ready() -> void:
	
	neighbors = get_neighbors()
	
	
	for found_tile in neighbors:
			
		if !found_tile.interacted_with.is_connected(on_neighbor_interaction):
			found_tile.interacted_with.connect(on_neighbor_interaction)
			
		if found_tile.components.has_node("LandMine"):
				continue
		found_tile.mesh_instance_3d.material_overlay = LAND_MINE_ADJACENT

	tile.mesh_instance_3d.mesh.surface_set_material(0, LAND_MINE)
		
	
func get_neighbors() -> Array:
	
	var n_list: Array
	
	var row = tile.get_parent()
	var grid = row.get_parent()
	
	var x_index = tile.get_index()
	var y_index = row.get_index()
	
	for y in range(-1, 2):
		if y_index + y >= grid.get_child_count() || y_index + y < 0:
			continue
		
		for x in range(-1,2):
			if x_index + x >= row.get_child_count() || x_index + x < 0:
				continue
			
			var found_tile = grid.get_child(y + y_index).get_child(x + x_index)

			n_list.append(found_tile)
	
	return n_list
	
func reconnect_neighbors() -> void:
	
	for found_tile in neighbors:
		# Disconnect
		if found_tile.interacted_with.is_connected(on_neighbor_interaction):
			found_tile.interacted_with.disconnect(on_neighbor_interaction)
			if found_tile.components.has_node("LandMine"):
				continue
			
			found_tile.mesh_instance_3d.material_overlay = null
				
	var new_neighbors = get_neighbors()
	neighbors = new_neighbors
	
	for new_tile in new_neighbors:
		# Connect
		if !new_tile.mesh_instance_3d.visible:
			continue
		
		if !new_tile.interacted_with.is_connected(on_neighbor_interaction):
			new_tile.interacted_with.connect(on_neighbor_interaction)
			

			if(new_tile == tile):
				new_tile.mesh_instance_3d.material_overlay = LAND_MINE
				continue
				
			if new_tile.components.has_node("LandMine"):
				continue
				
			new_tile.mesh_instance_3d.material_overlay = LAND_MINE_ADJACENT

func on_turn_end() -> void:
	
	for found_tile in neighbors:
		found_tile.animation_player.play("GetShot")
		
	available = false

func on_action(_callable_action: Callable, _action_arguments) -> void:
	if _callable_action.get_method() == "shoot_tile":
		
		if tile.components.has_node("ReflectBullet"):
			return
		
		on_turn_end()
	
func on_neighbor_interaction() -> void:	
	if !tile.get_child(0).visible:
		return
		
	reconnect_neighbors()
	
	interactions += 1
	
	if interactions >= max_interaction:
		available = true
	
	
