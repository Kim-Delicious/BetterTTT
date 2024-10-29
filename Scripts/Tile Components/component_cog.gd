extends CustomTileComponent


var direction = -1

const TILE_COG = preload("res://Resources/Material/tile_cog.tres")
const TILE_COG_COUNTER = preload("res://Resources/Material/tile_cog_counter.tres")
### NOTE: Changes direction when shot?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_texture()
	
	
	
func on_action(_callable_action: Callable, _action_arguments) -> void:
	
	direction *= -1
	change_texture()
	
func on_round_end() -> void:
	
	if !tile.get_child(0).visible: # MeshInstance
		return
	
	
	if direction == -1:
		move_counter_clock()
	else:
		move_clockwise()
		
func change_texture() -> void:
	var mesh_3d: MeshInstance3D = tile.mesh_instance_3d

	
	if direction == 1:
	
		mesh_3d.mesh.surface_set_material(0, TILE_COG)	
		
	else:
		mesh_3d.mesh.surface_set_material(0, TILE_COG_COUNTER)	
	
#region CounterClockWise	

func move_counter_clock() -> void:
	var row = tile.get_parent()
	
	var x_index = tile.get_index()
		
	if x_index == 0:
		
		rotate_around_l()
		return
	elif x_index == row.get_child_count() - 1:
		
		rotate_around_r()
		return
		
	rotate_around()

func rotate_around_l() -> void:
	
	var row = tile.get_parent()
	
	### Top Left
	move_tile(row.get_child_count()-1, -1, 0, 1, "Down")	
	### Left
	move_tile(row.get_child_count()-1, 0, -1, 1, "Down")
	### Bottom Left
	move_tile(row.get_child_count(), 1, -row.get_child_count(), 0, "LeftEdge")
	
	## Bottom
	move_tile(1, 1, 0, 0, "Right")
	## Bottom Right
	move_tile(2, 1, -1, -1, "Up")
	# Right
	move_tile(2, 0, -1, -1, "Up")
	## Top Right
	move_tile(2, -1, -2, 0, "Left")
	
	#### Top
	move_tile(1, -1, row.get_child_count()-1, 0, "RightEdge")
	
	tile.animation_player.play("CogLeft")
	
func rotate_around_r() -> void:
	
	var row = tile.get_parent()
	
	### Top Left
	move_tile(-1, -1, 0, 1, "Down")	
	### Left
	move_tile(-1, 0, -1, 1, "Down")
	### Bottom Left
	move_tile(0, 1, 0, 0, "Right")
	
	## Bottom
	move_tile(1, 1, -row.get_child_count(), 0, "LeftEdge")
	## Bottom Right
	move_tile(-row.get_child_count() + 2, 1, -1, -1, "Up")
	## Right
	move_tile(-row.get_child_count() + 2, 0, -1, -1, "Up")
	### Top Right
	move_tile(-row.get_child_count() + 2, -1, row.get_child_count()-1, 0, "RightEdge")
	### Top
	move_tile(-1, -1, 0, 0, "Left")
	
	tile.animation_player.play("CogLeft")		

func rotate_around() -> void:
	
		
	### Top Left
	move_tile(-1, -1, 0, 1, "Down")	
	### Left
	move_tile(-1, 0, -1, 1, "Down")
	### Bottom Left
	move_tile(0, 1, 0, 0, "Right")
	## Bottom
	move_tile(1, 1, 0, 0, "Right")
	## Bottom Right
	move_tile(2, 1, -1, -1, "Up")
	# Right
	move_tile(2, 0, -2, -1, "Up")
	## Top Right
	move_tile(1, -1, -1, 0, "Left")
	#### Top
	move_tile(-1, -1, 0, 0, "Left")
	
	tile.animation_player.play("CogLeft")
#endregion	
	
#region ClockWise	

func move_clockwise() -> void:
	var row = tile.get_parent()
	
	var x_index = tile.get_index()
		
	if x_index == 0:
		
		alt_rotate_around_l()
		return
	elif x_index == row.get_child_count() - 1:
		
		alt_rotate_around_r()
		return
		
	alt_rotate_around()

func alt_rotate_around_l() -> void:
	
	var row = tile.get_parent()
	
	### Bottom Left
	move_tile(row.get_child_count()-1, 1, 0, -1, "Up")
	### Left
	move_tile(row.get_child_count()-1, 0, -1, -1, "Up")
	### Top Left
	move_tile(row.get_child_count(), -1, -row.get_child_count(), 0, "LeftEdge")	
	
	#### Top
	move_tile(1, -1, 0, 0, "Right")
	## Top Right
	move_tile(2, -1, -1, 1, "Down")
	# Right
	move_tile(2, 0, -1, 1, "Down")
	## Bottom Right
	move_tile(2, 1, -1, 0, "Left")
	
	## Bottom
	move_tile(0, 1, row.get_child_count()-1, 0, "RightEdge")
	
	tile.animation_player.play("CogRight")
	
func alt_rotate_around_r() -> void:
	
	var row = tile.get_parent()
	
	### Bottom Left
	move_tile(-1, 1, 0, -1, "Up")
	### Left
	move_tile(-1, 0, -1, -1, "Up")
	### Top Left
	move_tile(0, -1, 0, 0, "Right")	
	
	#### Top
	move_tile(1, -1, -row.get_child_count(), 0, "LeftEdge")
	## Top Right
	move_tile(-row.get_child_count()+2, -1, -row.get_child_count()-2, 1, "Down")
	# Right
	move_tile(-row.get_child_count()+2, 0, -1, 1, "Down")
	## Bottom Right
	move_tile(-row.get_child_count()+2, 1, -2, 0, "RightEdge")
	
	## Bottom
	move_tile(-1, 1, 0, 0, "Left")
	
	tile.animation_player.play("CogRight")		

func alt_rotate_around() -> void:
	
		
	### Bottom Left
	move_tile(-1, 1, 0, -1, "Up")
	### Left
	move_tile(-1, 0, -1, -1, "Up")
	### Top Left
	move_tile(0, -1, 0, 0, "Right")	
	#### Top
	move_tile(1, -1, 0, 0, "Right")
	## Top Right
	move_tile(2, -1, -1, 1, "Down")
	# Right
	move_tile(2, 0, -1, 1, "Down")
	## Bottom Right
	move_tile(0, 1, 0, 0, "Left")
	## Bottom
	move_tile(-1, 1, 0, 0, "Left")
	
	tile.animation_player.play("CogRight")
#endregion	
	
func move_tile(target_x, target_y, next_x, next_y, anim_direction: String) -> void:
	var row = tile.get_parent()
	var grid = row.get_parent()
	
	var found_tile = get_relative_tile(target_x, target_y)
				
	var final_index = []
	
	final_index.append(found_tile.get_index() + next_x)
	final_index.append(found_tile.get_parent().get_index() + next_y)
		
	move_to_new_position_and_parent(found_tile, final_index[0], final_index[1], grid)
	
	
	var next_row_index = found_tile.get_parent().get_index() 
	
	if next_row_index + next_y > grid.get_child_count() - 1:
		next_y = 0
		next_row_index = 0
	
	
	var ref_row = grid.get_child(next_row_index + next_y)
	
	match anim_direction:
		"Left":
			to_left(found_tile)
		"Up":
			to_up(found_tile)
		"Down":
			to_down(found_tile)
		"Right":
			to_right(found_tile)
		"LeftEdge":
			to_left_edge(found_tile, ref_row.get_child_count() - 2)
		"RightEdge":
			to_right_edge(found_tile, ref_row.get_child_count() - 1)
		_:
			return
	
	

	
	
func get_relative_tile(new_x_index, new_y_index) -> Node3D:
	
	var row = tile.get_parent()
	var grid = row.get_parent()
	
	var x_index = tile.get_index()
	var y_index = row.get_index()
	
	var final_x = x_index
	var final_y = y_index
	
	
		
	if new_y_index <= -1:
		final_y = get_top_index(y_index + new_y_index + 1, grid)
	elif new_y_index >= 1:
		final_y = get_bottom_index(y_index + new_y_index - 1, grid)
		
		
	var new_row = grid.get_child(final_y)
			
	if new_x_index <= -1:
			final_x = get_left_index(x_index + new_x_index + 1, new_row)
		
	elif new_x_index >= 1:
		final_x = get_right_index(x_index + new_x_index - 1, new_row)
		
		
		
		

			
	return new_row.get_child(final_x)
	
	
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
		
	#print("Starting position: " + str(starting_tile.get_index() ) + ", " + str(starting_tile.get_parent().get_index() ) )
		
	starting_tile.reparent(new_row)
	new_row.move_child(starting_tile, new_x)
	
	#print("Ending position: " + str(starting_tile.get_index() ) + ", " + str(starting_tile.get_parent().get_index() ) )
		


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
		
	if x_index < row.get_child_count() - 1:
		return x_index + 1
		
	return 0
	
func get_top_index(y_index, grid) -> int:
	
	
	if y_index - 1 >= 0:
		return y_index - 1
		
	return grid.get_child_count() - 1
	
	
func get_bottom_index(y_index, grid) -> int:
		
	if y_index  < grid.get_child_count() - 1:
		return y_index + 1
		
	return 0
	
