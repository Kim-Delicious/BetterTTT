extends Node3D

@onready var symbol: Node3D = $AnimationTarget/Symbol
@onready var animation_player: AnimationPlayer = $AnimationTarget/AnimationPlayer
@onready var button_3d: StaticBody3D = $AnimationTarget/Button3D

var can_place = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func play_animation(anim_name: String)	-> void:
	animation_player.play(anim_name)
	symbol.animation_player.play(anim_name)
	
	
	

	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	symbol._on_animation_player_animation_finished(anim_name)
