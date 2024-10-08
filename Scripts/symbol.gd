extends Node3D

enum SymbolType {Empty = -1, Circle, Mult, Tri, Diamond}


@export var symbol_type = SymbolType.Empty

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

	
signal mid_tile_place

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_symbol_texture()
	
		
	
func change_symbol(chosen_symbol) -> void:
	symbol_type = chosen_symbol
	set_symbol_texture()
	
func set_symbol_texture() -> void:
	match symbol_type:
		SymbolType.Circle:
			sprite_3d.texture = preload("res://Textures/Sticker_Circle.png")
			pass
		SymbolType.Mult:
			sprite_3d.texture = preload("res://Textures/Sticker_Mult.png")
			pass
		SymbolType.Tri:
			sprite_3d.texture = preload("res://Textures/Sticker_Tri.png")
			pass
		SymbolType.Diamond:
			sprite_3d.texture = preload("res://Textures/Sticker_Diamond.png")
			pass
		_:
			sprite_3d.texture = null
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	#if anim_name == "AddSticker":
	mid_tile_place.emit()
