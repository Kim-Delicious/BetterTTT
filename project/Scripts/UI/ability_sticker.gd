extends TextureButton

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var original_position
var original_z
var move_setting = 0

@export var hover_color = Color.BLACK
@export var press_color = Color.BLACK

signal pushed_on

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position
	original_z = z_index
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	match move_setting:
		0:
			return
		1:
			move_up()
		2:
			move_down()
			
	pass



func move_up() -> void:
	
	position.y = lerp(position.y, original_position.y - 8, 0.5)
	
	if is_equal_approx(position.y, original_position.y - 8) :
		move_setting = 0
	
	
func move_down() -> void:
	
	position.y = lerp(position.y, original_position.y, 0.5)
	
	if is_equal_approx(position.y, original_position.y) :
		move_setting = 0


func _on_mouse_entered() -> void:
	
	move_setting = 1
	z_index += 30
	
	modulate = hover_color


func _on_mouse_exited() -> void:
	move_setting = 2
	z_index = original_z
	
	modulate = Color.WHITE


func _on_button_down() -> void:
	modulate = press_color


func _on_button_up() -> void:
	modulate = hover_color


func _on_pressed() -> void:
	pushed_on.emit(get_parent().get_index())
