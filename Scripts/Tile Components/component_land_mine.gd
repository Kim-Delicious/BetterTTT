extends CustomTileComponent



var interactions = 0

var neighbors: Array

const LAND_MINE = preload("res://Resources/Material/land_mine.tres")
const LAND_MINE_ADJACENT = preload("res://Resources/Material/land_mine_adjacent.tres")
func _ready() -> void:
	pass
	

	
func after_tile_ready() -> void:
	
	neighbors = get_neighbors()
	
	
	for found_tile in neighbors:
			
		if !found_tile.interacted_with.is_connected(on_neighbor_interaction):
			found_tile.interacted_with.connect(on_neighbor_interaction)
			
		found_tile.mesh_instance_3d.set_surface_override_material(0, LAND_MINE_ADJACENT)

	tile.mesh_instance_3d.set_surface_override_material(0, LAND_MINE)
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
			found_tile.mesh_instance_3d.set_surface_override_material(0, null)
				
	var new_neighbors = get_neighbors()
	neighbors = new_neighbors
	
	for new_tile in new_neighbors:
		# Connect
		if !new_tile.mesh_instance_3d.visible:
			continue
		
		if !new_tile.interacted_with.is_connected(on_neighbor_interaction):
			new_tile.interacted_with.connect(on_neighbor_interaction)
			new_tile.mesh_instance_3d.set_surface_override_material(0, LAND_MINE_ADJACENT)



func on_action(_callable_action: Callable, _action_arguments) -> void:
	#interacted.emit()
	pass
	
func on_neighbor_interaction() -> void:	
	reconnect_neighbors()
	
	interactions += 1
	
	if interactions >= 5:
	
		for found_tile in neighbors:
			found_tile.animation_player.play("GetShot")
	
