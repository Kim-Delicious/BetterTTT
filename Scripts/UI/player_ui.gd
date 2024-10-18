extends Control

@onready var player_symbol: TextureButton = $DisplayAnchor/TurnDial/Node/AbilitySticker
@onready var inventory: Control = $DisplayAnchor/Inventory
@onready var animation_player: AnimationPlayer = $DisplayAnchor/AnimationPlayer

signal player_ui_anim_fin
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func update_symbol_text_count(amount : int) -> void:
	player_symbol.get_child(0).get_child(1).text = str(amount)
	
func update_ability_text_count(label_index, amount : int) -> void:
	var ability_sticker = inventory.get_child(label_index).get_child(0)
	var count_label = ability_sticker.get_child(0).get_child(1)
	count_label.text = str(amount)
	
func add_missing_center_pieces(label_index, player_id, player) -> void:
	
	var center_piece = inventory.get_child(label_index)

	if center_piece.name != "Center":
		
		var first_center = inventory.get_child(1)
		var last_center = inventory.get_child(inventory.get_child_count() - 2)

		var piece_copy = first_center.duplicate()
		
		var spacing =  48 - (player.get_child_count()-2) * 4
		if player_id == 0 || player_id == 2:
			last_center.add_sibling(piece_copy)
			piece_copy.position.x = 64 + spacing * (label_index-1)
			piece_copy.z_index = last_center.z_index - 1
		else:
			last_center.add_sibling(piece_copy)
			piece_copy.position.x = -64 - spacing * (label_index-1)
			piece_copy.z_index = last_center.z_index - 1
			
					
	
func set_symbol_texture(symbol_texture) -> void:
	player_symbol.texture_normal = symbol_texture
	
func set_ability_sticker_texture(label_index, texture) -> void:
		
	var ability_sticker = inventory.get_child(label_index).get_child(0)
	ability_sticker.texture_normal = texture
	
func update_selection_indicator(which_player) -> void:
	
	if !which_player.on_turn:
		return
		
	$DisplayAnchor/TurnDial/Node/AbilitySticker.get_child(1).play("HideIndicator")
		
	for i in range(1, inventory.get_child_count()-1):
		var ability_sticker = inventory.get_child(i).get_child(0)
		
		ability_sticker.get_child(1).play("HideIndicator")
		
		
	if which_player.component_index == 0:
		
		$DisplayAnchor/TurnDial/Node/AbilitySticker.get_child(1).play("ShowIndicator")#var ability_sticker = $DisplayAnchor/TurnDial/PlayerSymbol

		
	else:
		
		var ability_sticker = inventory.get_child(which_player.component_index).get_child(0)
		ability_sticker.get_child(1).play("ShowIndicator")
		
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	player_ui_anim_fin.emit(anim_name)
	
