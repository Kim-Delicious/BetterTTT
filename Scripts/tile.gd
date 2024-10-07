extends Node3D

@onready var symbol: Node3D = $AnimationTarget/Symbol
@onready var animation_player: AnimationPlayer = $AnimationTarget/AnimationPlayer
@onready var button_3d: StaticBody3D = $AnimationTarget/Button3D

var can_place = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func action_on_tile(which_player) -> void:
	if can_place:
		symbol.change_symbol(which_player)
		animation_player.play("AddSticker")
	
func shoot_tile(which_player) -> void:
	can_place = false
	symbol.change_symbol(-1)
	animation_player.play("GetShot")
	
