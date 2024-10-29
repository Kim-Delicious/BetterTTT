extends Node3D

@onready var symbol: Node3D = $AnimationTarget/Symbol
@onready var animation_player: AnimationPlayer = $AnimationTarget/AnimationPlayer
@onready var button_3d: StaticBody3D = $AnimationTarget/Button3D
@onready var mouse_hover_sprite: Sprite3D = $AnimationTarget/MouseHoverSprite
@onready var mesh_instance_3d: MeshInstance3D = $AnimationTarget/MeshInstance3D

@onready var components: Node = $Components

@export var components_to_add: Array

@onready var original_position = position
var can_place = true

var do_detect_mouse = false
var do_return_to_normal = false

var command_buffer: Array = []

signal components_executed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for path in components_to_add:
		var component: Node = load(path).instantiate()
		components.add_child(component)
			
	for comp in components.get_children():
		
		if comp.has_method("on_round_end"):
			command_buffer.append(comp.on_round_end)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if do_return_to_normal:
		return_to_normal()

	if !do_detect_mouse:
		return
		
		
	rotate_towards_cursor()
	
func play_animation(anim_name: String)	-> void:
	animation_player.play(anim_name)
	symbol.animation_player.play(anim_name)
	
func rotate_towards_cursor() -> void:
	
	var raycast_result = get_raycast()
	
	var hit_position = raycast_result.get("position")
	
	if hit_position == null:
		return
	
	var diff = Vector3(global_position.x - hit_position.x, -position.y - hit_position.y, global_position.z - hit_position.z)
	
	var new_rotation : Vector3
	new_rotation.x = deg_to_rad(-diff.z)
	new_rotation.z = deg_to_rad(diff.x)
	
	rotation.x = lerp_angle(rotation.x, new_rotation.x, 0.5)
	rotation.z = lerp_angle(rotation.z, new_rotation.z, 0.5)
	
		
	diff.y = clamp(diff.y, -6, 6)
	
	position.y = lerp(position.y, original_position.y - diff.y * 0.25, .05)

func return_to_normal() -> void:
	
	if is_equal_approx(position.y, original_position.y):
		
		if is_equal_approx(rotation.x, 0) && is_equal_approx(rotation.z, 0):
			do_return_to_normal = false
			return

	position.y = lerp(position.y, original_position.y, 0.25)
	
	rotation.x = lerp_angle(rotation.x, 0, 0.5)
	rotation.z = lerp_angle(rotation.x, 0, 0.5)

func get_raycast():
	
	var camera = get_viewport().get_camera_3d()
	
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 250
	
	var from_position = camera.project_ray_origin(mouse_position)
	var to_position = from_position + camera.project_ray_normal(mouse_position) * ray_length
	
	var space = get_world_3d().direct_space_state
	
	var ray_query = PhysicsRayQueryParameters3D.new()
	
	
	ray_query.from = from_position
	ray_query.to = to_position
	ray_query.collide_with_areas = true
	
	var raycast_result = space.intersect_ray(ray_query)
		
	return raycast_result

func reset_original_position() -> void:
	original_position = position

func start_dectecting_mouse() -> void:
	mouse_hover_sprite.show()
	do_detect_mouse = true
	
func stop_detecting_mouse() -> void:
	mouse_hover_sprite.hide()
	do_detect_mouse = false
	do_return_to_normal = true

func action_on_components(callable_action: Callable, action_arguments) -> void:
	
	if components == null:
		return
	print(components.get_child_count())
	for component in components.get_children():
		print(component.name)
		component.on_action(callable_action, action_arguments)

func activate_round_end_components() -> void:
	
	for command in command_buffer:
		command.call_deferred()
		
	components_executed.emit.call_deferred()


func replace_component(component_index, new_component_name: String) -> void:
	
	components.get_child(component_index).queue_free()
	
	var path = "res://Scenes/Tile Components/" + new_component_name + ".tscn"
	var comp = load(path).instantiate()
	components.add_child(comp)
	components.move_child(comp, component_index)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	symbol._on_animation_player_animation_finished(anim_name)


func _on_button_3d_mouse_entered() -> void:
	if visible == false || get_child(0).get_child(0).visible == false:
		return
		
	start_dectecting_mouse()
	

func _on_button_3d_mouse_exited() -> void:
	if visible == false || get_child(0).visible == false  || get_child(0).get_child(0).visible == false:
		return
		
	stop_detecting_mouse()
	
