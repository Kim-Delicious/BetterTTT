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
	
	#First column of invisible tiles excluding corners
	if grid_x == 0:
		if grid_y >= 0 && grid_y <= y_max:
		# Move Row Left
			decrement()
			which_tile.action_on_components(move_row,[grid_y, -1])
			return
		pass
		
	# Last column
	elif grid_x == x_max:
		if grid_y >= 0 && grid_y <= y_max:
			# Move Row Right
			decrement()
			which_tile.action_on_components(move_row,[grid_y, 1])
			return
		pass
	
	
func move_row(which_row_index, direction = -1) -> void:
	
	var row = grid.get_child(which_row_index)

	# Move in-between tiles
	for i in range(0, row.get_child_count()):
		var tile = row.get_child(i)
		if direction == -1:
			if i == 0:
				continue
			tile.animation_player.play("MoveLeft")
			tile.position.x += 7
			tile.reset_original_position()

			
			continue
		else:
			tile.position.x -= 7
			tile.animation_player.play("MoveRight")
			tile.reset_original_position()

			continue
			
	# Move Edges
	if direction == -1:
		var first_tile = row.get_child(0)
		row.move_child(first_tile, row.get_child_count() - 1)
		first_tile.position.x -= 7 * ( row.get_child_count() - 1)
		
		first_tile.reset_original_position()
		
		first_tile.animation_player.play("MoveLeft")

	else:
		var last_tile = row.get_child(row.get_child_count() - 1)
		
		row.move_child(last_tile, 0)
		last_tile.position.x += 7 * ( row.get_child_count())
		
		last_tile.reset_original_position()
		
		last_tile.animation_player.play("MoveRight")

	update_tile_interactions(which_row_index, direction)

func update_tile_interactions(which_row_index, direction) -> void:
	
	var row = grid.get_child(which_row_index)

	# Move in-between tiles
	for i in range(0, row.get_child_count()):
		var tile = row.get_child(i)
		if direction == -1:
			if i == 0:
				continue

			tile.on_component_interacted()

			
			continue
		else:

			tile.on_component_interacted()

			
			continue
			
	# Move Edges
	if direction == -1:
		var first_tile = row.get_child(0)

		first_tile.on_component_interacted()

	else:
		var last_tile = row.get_child(row.get_child_count() - 1)

		last_tile.on_component_interacted()
		
		


		
	
	

func decrement(amount = 1) -> void:
	count -= amount
	
	if count <= 0:
		count = 0
		available = false
		
