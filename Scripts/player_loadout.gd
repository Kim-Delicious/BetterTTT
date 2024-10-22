extends Panel

@export var character_name = "MELMN"

enum Character {Wizard, Sharpshooter}
@export var character := Character.Wizard

enum Symbol {Empty = -1, Circle, Mult, Tri, Diamond}
@export var main_sticker := Symbol.Circle

enum Ability {Empty = -1, TeleRow, TeleColumn, Sniper}

@export var abilities = [Ability.TeleRow]

@onready var sillouette: TextureRect = $Control/Sillouette
@onready var main_sticker_node: TextureButton = $Inventory/MainSticker
@onready var inventory: Control = $Inventory
@onready var player_name = $Control/VBoxContainer/PlayerName

var max_abilities = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_main_sticker_image()
	set_character_image()
	set_ability_images()
	set_player_name()


	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func set_player_name() -> void:
	player_name.text = character_name.to_upper()
	
func update_character(which_button) -> void:
	character = which_button
	set_character_image()
			
	
			
func set_character_image() -> void:
	match character:
		Character.Wizard:
			sillouette.texture = preload("res://Textures/SillouetteWizard_Grayscale.png")
			player_name.text = "MELMN"
			player_name.self_modulate = Color.CORNFLOWER_BLUE
			
			
		Character.Sharpshooter:
			sillouette.texture = preload("res://Textures/SillouetteGunslinger_Grayscale.png")
			player_name.text = "DYRT"
			player_name.self_modulate = Color.DARK_RED


func update_main_sticker() -> void:
	
	main_sticker += 1
	
	if main_sticker > Symbol.size() - 2:
		main_sticker = Symbol.Empty

	
	set_main_sticker_image()
			
func set_main_sticker_image() -> void:
	match main_sticker:
		Symbol.Circle:
			main_sticker_node.texture_normal = preload("res://Textures/Sticker_Circle.png")
		Symbol.Mult:
			main_sticker_node.texture_normal = preload("res://Textures/Sticker_Mult.png")
		Symbol.Tri:
			main_sticker_node.texture_normal = preload("res://Textures/Sticker_Tri.png")
		Symbol.Diamond:
			main_sticker_node.texture_normal = preload("res://Textures/Sticker_Diamond.png")
		Symbol.Empty:
			main_sticker_node.texture_normal = null
			
	
func add_or_change_abilities(which_button) -> void:
	
	print(which_button)
	
	if abilities.size() < max_abilities:
		abilities.append(which_button)
		set_ability_images()
		return
		
	abilities[abilities.size() - 1] = which_button
	
	set_ability_images()
	
func remove_abilities(which_button) -> void:
	
	
	abilities.pop_at(which_button)
	
	#inventory.get_child(which_button + 1).hide()
	inventory.get_child(abilities.size() + 1).hide()
	set_ability_images()
	
	
func set_ability_images() -> void:
	
	for i in range(1, inventory.get_child_count()):
		var sticker: TextureButton = inventory.get_child(i)
		

		
		if abilities.size() < i:
			return
			
		sticker.show()
		
		match abilities[i-1]:
			Ability.TeleRow:
				sticker.texture_normal = preload("res://Textures/TelekenisisSticker.png")
			Ability.TeleColumn:
				sticker.texture_normal = preload("res://Textures/TelekenisisColumnSticker.png")
			Ability.Sniper:
				sticker.texture_normal = preload("res://Textures/SniperSticker.png")
			-1:
				sticker.hide()
			_:
				sticker.hide()
		
	
	
