extends Control

@onready var player_symbol: Sprite2D = $DisplayAnchor/TurnDial/PlayerSymbol
@onready var symbol_count_sticker: Control = $DisplayAnchor/TurnDial/PlayerSymbol/CountSticker
@onready var inventory: Control = $DisplayAnchor/Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func update_symbol_text_count(amount : int) -> void:
	symbol_count_sticker.get_child(1).text = str(amount)
	
func update_ability_text_count(label_index, amount : int) -> void:
	var ability_sticker = inventory.get_child(label_index).get_child(0)
	var count_label = ability_sticker.get_child(0).get_child(1)
	count_label.text = str(amount)
	
func set_symbol_texture(symbol_texture) -> void:
	player_symbol.texture = symbol_texture
	
func set_ability_sticker_texture(label_index, texture) -> void:
	var ability_sticker = inventory.get_child(label_index).get_child(0)
	ability_sticker.texture = texture
	
	
