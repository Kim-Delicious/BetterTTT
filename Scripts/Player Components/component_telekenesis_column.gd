extends PlayerComponent

@onready var grid: Node3D = $"../../../Grid"

func _ready() -> void:
	refresh()
	
func refresh() -> void:
	count = max_count
	available = true


func take_action(_source_node, on_which_tile) -> void:
	if count <= 0:
		return
		
	if on_which_tile.visible == false:
		return
		
	if on_which_tile.get_child(0).get_child(0).visible == false: # MeshInstance3D
		return
	
	slide_row_or_column(on_which_tile)
	
func slide_row_or_column(which_tile) -> void:
	
	var grid_x = which_tile.get_index()
	var grid_y = which_tile.get_parent().get_index()
	
	var x_max = grid.get_child_count() - 1
	var y_max = which_tile.get_parent().get_child_count() - 1
	
	if grid_y == 0:
		if grid_x >= 0 && grid_x <= x_max:
			# Move Column Up
			decrement()
			#move_column(grid_x, -1)
			which_tile.action_on_components(move_column, [grid_x, -1])
			return

	# Last Row
	elif grid_y == y_max:
		if grid_x >= 0 && grid_x <= x_max:
			#Move Column Down
			decrement()
			which_tile.action_on_components(move_column, [grid_x, 1])
			#move_column(grid_x, 1)
			return

		
		
func move_column(which_column_index, direction = -1) -> void:
	

	# Move in-between tiles
	
	if direction == -1:
		for i in range(1, grid.get_child_count()):
			var row = grid.get_child(i)
			var tile = row.get_child(which_column_index)
			
			var new_row = grid.get_child(i - 1)
			
			tile.reparent(new_row)
			new_row.move_child(tile, which_column_index)
			
			tile.position.z = 0
			
			tile.reset_original_position()
			
			tile.animation_player.play("MoveUp")

			
	else:		
		for n in range(grid.get_child_count() - 1):
			var i = grid.get_child_count() - 2 - n
			
			var row = grid.get_child(i)
			var tile = row.get_child(which_column_index)

			var new_row = grid.get_child(i + 1)
			
			tile.reparent(new_row)
			new_row.move_child(tile, which_column_index)
			
			tile.position.z = 0
			
			tile.reset_original_position()
						
			tile.animation_player.play("MoveDown")

			
	# Move Edges
	if direction == -1:
		var row = grid.get_child(0)
		var first_tile = row.get_child(which_column_index + 1)
		
		var last_row = grid.get_child(grid.get_child_count() - 1)
		
		first_tile.reparent(last_row)
		last_row.move_child(first_tile, which_column_index)
		
		first_tile.position.z = 0
		
		first_tile.reset_original_position()
				
		first_tile.animation_player.play("MoveUp")


	else:
		var last_row = grid.get_child(grid.get_child_count() - 1)
		var last_tile = last_row.get_child(which_column_index + 1)
				
		var row = grid.get_child(0)
		
		last_tile.reparent(row)
		row.move_child(last_tile, which_column_index)
		
		
		last_tile.position.z = 0
		
		last_tile.reset_original_position()
		
		last_tile.animation_player.play("MoveDown")

	update_tile_interactions(which_column_index, direction)


		
	
func update_tile_interactions(which_column_index, direction) -> void:
	
	if direction == -1:
		for i in range(1, grid.get_child_count()):
			var row = grid.get_child(i)
			var tile = row.get_child(which_column_index)
		
			tile.on_component_interacted()
			
	else:		
		for n in range(grid.get_child_count() - 1):
			var i = grid.get_child_count() - 2 - n
			
			var row = grid.get_child(i)
			var tile = row.get_child(which_column_index)

			tile.on_component_interacted()

			
	# Move Edges
	if direction == -1:
		var row = grid.get_child(0)
		var first_tile = row.get_child(which_column_index + 1)
		

		first_tile.on_component_interacted()


	else:
		var last_row = grid.get_child(grid.get_child_count() - 1)
		var last_tile = last_row.get_child(which_column_index + 1)

		last_tile.on_component_interacted()
	

func decrement(amount = 1) -> void:
	count -= amount
	
	if count <= 0:
		count = 0
		available = false
		
