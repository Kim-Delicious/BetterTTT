extends Node3D

enum SymbolType {Empty = -1, Circle, Mult, Tri, Diamond}


@export var symbol_type = SymbolType.Empty

@onready var sprite_3d: Sprite3D = $Sprite3D
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_symbol_texture()
	
		
	
func change_symbol(chosen_symbol) -> void:
	symbol_type = chosen_symbol
	set_symbol_texture()
	
func set_symbol_texture() -> void:
	match symbol_type:
		SymbolType.Circle:
			sprite_3d.texture = load("res://Textures/Sticker_Circle.png")
			pass
		SymbolType.Mult:
			sprite_3d.texture = load("res://Textures/Sticker_Mult.png")
			pass
		SymbolType.Tri:
			sprite_3d.texture = load("res://Textures/Sticker_Tri.png")
			pass
		SymbolType.Diamond:
			sprite_3d.texture = load("res://Textures/Sticker_Diamond.png")
			pass
		_:
			sprite_3d.texture = null
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
