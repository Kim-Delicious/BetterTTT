extends Camera3D

var location = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var can_move = true

var current_angle = 0

@export var rotate_speed = 0.5
@export var orbit_radius = 45

var rotate_direction = 1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orbit_radius = GlobalSettings.camera_zoom
	position.y = GlobalSettings.camera_height
	
	rotate_around_center(0, 1)
	
	process_mode = PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	orbit_radius = GlobalSettings.camera_zoom
	position.y = GlobalSettings.camera_height
	rotate_around_center(_delta, 0)
	
	limit_variables()
	
	if can_move:
		return
		
	stop_rotating_at_limits()
	rotate_around_center(_delta, rotate_direction)
	
	
	
	
	
	
		

	
	
func _input(event: InputEvent) -> void:
	
	#if event.is_action("AngleCameraUp"):
		#orbit_radius -= 1
		#rotate_around_center(0, 0)
		#
	#elif event.is_action("AngleCameraDown"):
		#orbit_radius += 1
		#rotate_around_center(0, 0)
	#
	#if(event.is_action("ZoomInCamera")):
		#position.y -= 1
		#rotate_around_center(0, 0)
		#
	#elif(event.is_action("ZoomOutCamera")):
		#position.y += 1
		#rotate_around_center(0, 0)
	
	
	if !can_move:
		return
	
	if(event.is_action_pressed("MoveCameraLeft") ):
		

		increment(-1)
		rotate_direction = 1
		
		can_move = false
		

	elif(event.is_action_pressed("MoveCameraRight")):
		
		increment(1)
		rotate_direction = -1


		can_move = false
		
	
		
func increment(amount) -> void:
	
	location += amount
	
	if location > 3:
		location = 0
		
	elif location < 0:
		location = 3
	
func get_position_at_location() -> Vector3:
	
	var new_position: Vector3
	
	match location:
		1:
			new_position = Vector3(0, 64, -45)
		2:
			new_position = Vector3(-45, 64, 0)
		3:
			new_position = Vector3(0, 64, 45)
		4:
			new_position = Vector3(45, 64, 0)
			
	return new_position
	
func get_ninety_rotation(amount) -> Vector3:
	
	
	var rotate_amount := Vector3(0, amount, 0)
	
	var new_rotation := self.rotation_degrees + rotate_amount
	new_rotation = new_rotation.round()
	new_rotation.x = deg_to_rad(new_rotation.x)
	new_rotation.y = deg_to_rad(new_rotation.y)
	new_rotation.z = deg_to_rad(new_rotation.z)
	
			
	return new_rotation
	
func stop_rotating_at_limits() -> void:

	if location == 0 && 182 >= rotation_degrees.y && rotation_degrees.y >= 178:
		can_move = true
		return
	if location == 3 && 92 >= rotation_degrees.y && rotation_degrees.y >= 88:
		can_move = true
		return
	if location == 2 && 2 >= rotation_degrees.y && rotation_degrees.y >= -2:
		can_move = true
		return
	if location == 1 && -88 >= rotation_degrees.y && rotation_degrees.y >= -92:
		can_move = true
		return
	if location == 0 && -178 >= rotation_degrees.y && rotation_degrees.y >= -182:
		can_move = true
		return
		
	
func limit_variables() -> void:
	
	if position.y >= 128:
		position.y = 128
	elif position.y < 28:
		position.y = 28
		
	if orbit_radius >= 105:
		orbit_radius = 105
	elif orbit_radius < 5:
		orbit_radius = 5
		
	if current_angle >= deg_to_rad(360) || current_angle <= deg_to_rad(-360):
		current_angle = 0

	
	
func update_animation(anim_name, new_position,  new_rotation) -> void:
	
	var anim = animation_player.get_animation(anim_name)
	
	# Position
	# - First Key
	anim.track_set_key_value(0, 0, self.position)
	# - Second
	anim.track_set_key_value(0, 1, new_position)
	
	
	# Rotation
	# - First Key
	anim.track_set_key_value(1, 0, self.rotation)
	# - Second
	anim.track_set_key_value(1, 1, new_rotation)

func calculate_circular_position(radius, angle):
	
	var v = radius * Vector2.from_angle(angle)
		
	var new_pos = Vector3(v.x, position.y, v.y)
	
	return new_pos
	
func rotate_around_center(_delta, direction) ->  void:
	
	var new_pos = calculate_circular_position(orbit_radius, current_angle + deg_to_rad(-90))
		
	current_angle +=  deg_to_rad(135) * rotate_speed * _delta * direction
		
	
	look_at_from_position(new_pos, Vector3.ZERO, Vector3.UP)
	
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "MoveCamera":
		can_move = true
