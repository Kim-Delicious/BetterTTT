extends CustomTileComponent


var direction = -1


### NOTE: Changes direction when shot?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mesh_3d: MeshInstance3D = tile.mesh_instance_3d
	
	var cog_mat = preload("res://Resources/Material/tile_cog.tres")
	
	mesh_3d.mesh.surface_set_material(0, cog_mat)
	
	
func on_round_end() -> void:
	
	if !tile.get_child(0).visible: #MeshInstance
		return
	
	
	var row = tile.get_parent()
	var grid = row.get_parent()
	
	var x_index = tile.get_index()
	var y_index = row.get_index()
	
	
	print (row.get_child_count() - 1)
	if x_index == 0:
		
		rotate_around_l(x_index, y_index, grid, row)
		return
	elif x_index == row.get_child_count() - 1:
		
		rotate_around_r(x_index, y_index, grid, row)
		return
		
	rotate_around(x_index, y_index, grid, row)

func rotate_around_l(x_index, y_index, grid, row) -> void:
	
	# Top Left
		move_top_left(x_index, y_index, grid, row)
		## Left
		move_left.call_deferred(x_index, y_index, grid, row)
		## Bottom Left
		move_bottom_left_l.call_deferred(x_index, y_index, grid, row)
		### Bottom
		move_bottom.call_deferred(x_index+1, y_index, grid)
		#### Bottom Right
		move_bottom_right.call_deferred(x_index+1, y_index, grid, row)
		#### Right
		move_right.call_deferred(x_index+1, y_index, grid, row)
		### Top
		move_top_l.call_deferred(x_index, y_index, grid)
		#### Top Right
		move_top_right_l.call_deferred(x_index, y_index, grid, row)
		
		tile.animation_player.play("CogLeft")
		
	
func rotate_around_r(x_index, y_index, grid, row) -> void:
	
	# Top Left
		move_top_left(x_index, y_index, grid, row)
		## Left
		move_left.call_deferred(x_index+1, y_index, grid, row)
		## Bottom Left
		move_bottom_left.call_deferred(x_index+1, y_index, grid, row)
		### Bottom
		move_bottom_r.call_deferred(x_index+1, y_index, grid)
		##### Bottom Right
		move_bottom_right_r.call_deferred(x_index+1, y_index, grid, row)
		##### Right
		move_right_r.call_deferred(x_index+1, y_index, grid, row)
		###### Top Right
		move_top_right_r.call_deferred(x_index+1, y_index, grid, row)	
		##### Top
		move_top.call_deferred(x_index-1, y_index, grid)
		
		tile.animation_player.play("CogLeft")
		
		

func rotate_around(x_index, y_index, grid, row) -> void:
	
	# Top Left
	move_top_left(x_index, y_index, grid, row)
	## Left
	move_left.call_deferred(x_index+1, y_index, grid, row)
	## Bottom Left
	move_bottom_left.call_deferred(x_index+1, y_index, grid, row)
	### Bottom
	move_bottom.call_deferred(x_index+1, y_index, grid)
	### Bottom Right
	move_bottom_right.call_deferred(x_index+1, y_index, grid, row)
	### Right
	move_right.call_deferred(x_index+1, y_index, grid, row)
	### Top Right
	move_top_right.call_deferred(x_index-1, y_index, grid, row)
	## Top
	move_top.call_deferred(x_index-1, y_index, grid)
	
	tile.animation_player.play("CogLeft")
	
#region TopLeft

func move_top_left(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_left_index(first_x_index, row)
	var new_y_index = get_top_index(first_y_index, grid)
	
	var new_row = grid.get_child(new_y_index)
	
	var found_tile = new_row.get_child(new_x_index)

	
	move_to_new_position_and_parent(found_tile, new_x_index, new_y_index + 1, grid)
	
	to_down(found_tile)
	
	
#endregion
#region Left
func move_left(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_left_index(first_x_index, row)
	
	var found_tile = grid.get_child(first_y_index).get_child(new_x_index)
	
	move_to_new_position_and_parent(found_tile, first_x_index-2, first_y_index + 1, grid)
	
	to_down(found_tile)
	
#endregion
#region BottomLeft
func move_bottom_left(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_left_index(first_x_index, row)
	var new_y_index = get_bottom_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(new_x_index)
	
	move_to_new_position_and_parent(found_tile, new_x_index, new_y_index, grid)
	
	to_right(found_tile)
	
func move_bottom_left_l(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_left_index(first_x_index, row)
	var new_y_index = get_bottom_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(new_x_index+1)
	
	move_to_new_position_and_parent(found_tile, 0, new_y_index, grid)
	
	var ref_row = grid.get_child(new_y_index)
	
	to_left_edge(found_tile, ref_row.get_child_count() - 2)


#endregion
#region Bottom
func move_bottom(first_x_index, first_y_index, grid) -> void:
	
	var new_y_index = get_bottom_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(first_x_index)
	
	move_to_new_position_and_parent(found_tile, first_x_index, new_y_index, grid)
	
	to_right(found_tile)	
	
func move_bottom_r(first_x_index, first_y_index, grid) -> void:
	
	var new_y_index = get_bottom_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(first_x_index)
	
	move_to_new_position_and_parent(found_tile, 0, new_y_index, grid)
	
	var ref_row = grid.get_child(new_y_index)
	
	to_left_edge(found_tile, ref_row.get_child_count()-2)
	
		
#endregion
#region BottomRight
func move_bottom_right(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_right_index(first_x_index, row)
	var new_y_index = get_bottom_index(first_y_index, grid)
	
	if new_x_index == 0:
		new_x_index = row.get_child_count()
	
	var found_tile = grid.get_child(new_y_index).get_child(new_x_index)
		
	move_to_new_position_and_parent(found_tile, new_x_index-1, new_y_index - 1, grid)
	
	to_up(found_tile)

func move_bottom_right_r(_first_x_index, first_y_index, grid, _row) -> void:
	
	var new_x_index = 1
	var new_y_index = get_bottom_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(new_x_index)
	
	move_to_new_position_and_parent(found_tile, 0, new_y_index - 1, grid)
	
	to_up(found_tile)
	
#endregion
#region Right	
func move_right(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_right_index(first_x_index, row)
	
	var found_tile = grid.get_child(first_y_index).get_child(new_x_index)
	
	if new_x_index == row.get_child_count()-1:
		print(new_x_index)
		#new_x_index -= 1
		
	move_to_new_position_and_parent(found_tile, new_x_index-1, first_y_index - 1, grid)
	
	to_up(found_tile)
	
func move_right_r(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_right_index(first_x_index, row) + 1
	
	var found_tile = grid.get_child(first_y_index).get_child(new_x_index)
	
	move_to_new_position_and_parent(found_tile, 0, first_y_index - 1, grid)
	
	to_up(found_tile)

	
#endregion
#region TopRight
func move_top_right(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_right_index(first_x_index, row)
	var new_y_index = get_top_index(first_y_index, grid)
	
	
	
	var found_tile = grid.get_child(new_y_index).get_child(new_x_index)
	
	move_to_new_position_and_parent(found_tile, new_x_index, new_y_index, grid)
	
	to_left(found_tile)
	
func move_top_right_l(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_right_index(first_x_index, row)
	var new_y_index = get_top_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(new_x_index)
	
	move_to_new_position_and_parent(found_tile, new_x_index-1, new_y_index, grid)
	
	to_left(found_tile)
	
func move_top_right_r(first_x_index, first_y_index, grid, row) -> void:
	
	var new_x_index = get_right_index(first_x_index, row) + 1
	var new_y_index = get_top_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(new_x_index)
	
	var ref_row = grid.get_child(new_y_index)
	
	move_to_new_position_and_parent(found_tile, -1, new_y_index, grid)
	
	to_right_edge(found_tile, ref_row.get_child_count()-1)

	
#endregion
#region Top
func move_top(first_x_index, first_y_index, grid) -> void:
	
	var new_y_index = get_top_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(first_x_index)
	
	move_to_new_position_and_parent(found_tile, first_x_index, new_y_index, grid)
	

	to_left(found_tile)

	
func move_top_l(first_x_index, first_y_index, grid) -> void:
	
	var new_y_index = get_top_index(first_y_index, grid)
	
	var found_tile = grid.get_child(new_y_index).get_child(first_x_index)
	
	move_to_new_position_and_parent(found_tile, first_x_index - 1, new_y_index, grid)
	
	var ref_row = grid.get_child(new_y_index)
	
	to_right_edge(found_tile, ref_row.get_child_count()-1)
	
		
#endregion


	
	

	

	
func move_to_new_position_and_parent(starting_tile, target_x, target_y, grid) -> void:
	
	
	var new_row: Node3D
	
	if starting_tile == null:
		return
	
	
	
	if target_y > grid.get_child_count() - 1:
		
		# Move To Top
		
		new_row = grid.get_child(0)
		
	elif target_y < 0:
		
		# Move To Bottom
		
		new_row = grid.get_child(grid.get_child_count() - 1 )
	else:
		
		# Work Normally
		
		new_row = grid.get_child(target_y)

	var new_x
	
	#if target_x > new_row.get_child_count() - 1:
		#
		## Move to Left Side
		#
		#new_x = 0
		#
	#elif target_x < 0:
		#
		## Move to Right Side
		#
		#new_x = new_row.get_child_count() - 1
	#else:
		
	# Work normally
	new_x = target_x
		
	print("Starting position: " + str(starting_tile.get_index() ) + ", " + str(starting_tile.get_parent().get_index() ) )
		
	starting_tile.reparent(new_row)
	new_row.move_child(starting_tile, new_x)
	
	print("Ending position: " + str(starting_tile.get_index() ) + ", " + str(starting_tile.get_parent().get_index() ) )
		


func to_right(found_tile) -> void:
	
	if found_tile == null:
		return
	
	found_tile.position.x -= 7
	found_tile.reset_original_position()
	found_tile.animation_player.play("MoveRight")
		

func to_left(found_tile) -> void:
		
	if found_tile == null:
		return
		
	found_tile.position.x += 7
	found_tile.reset_original_position()
	found_tile.animation_player.play("MoveLeft")
	
func to_up(found_tile) -> void:
			
	if found_tile == null:
		return
		
	found_tile.position.z = 0
	found_tile.reset_original_position()
	found_tile.animation_player.play("MoveUp")
	
func to_down(found_tile) -> void:
			
	if found_tile == null:
		return
		
	found_tile.position.z = 0
	found_tile.reset_original_position()
	found_tile.animation_player.play("MoveDown")
	
	
func to_left_edge(found_tile, row_size) -> void:
	
	if found_tile == null:
		return
	
	
	found_tile.position.x += row_size * 7# TEMP! Replace later
	found_tile.reset_original_position()
	found_tile.animation_player.play("MoveRight")
	
func to_right_edge(found_tile, row_size) -> void:
	
	if found_tile == null:
		return
	
	found_tile.position.x -= row_size * 7# TEMP! Replace later
	found_tile.reset_original_position()
	found_tile.animation_player.play("MoveLeft")
	

func get_left_index(x_index, row) -> int:
	
	if x_index - 1 >= 0:
		return x_index - 1
		
	return row.get_child_count() - 1 
	
func get_right_index(x_index, row) -> int:
	
	if x_index + 1 < row.get_child_count():
		return x_index + 1
		
	return 0
	
func get_top_index(y_index, grid) -> int:
	
	if y_index - 1 >= 0:
		return y_index -1
		
	return grid.get_child_count() - 1
	
	
func get_bottom_index(y_index, grid) -> int:
	
	if y_index + 1 < grid.get_child_count():
		return y_index + 1
		
	return 0
	
