extends Control

@onready var main: VBoxContainer = $MainMenu

@onready var selection: Control = $SelectionMenu

@onready var player_container: HBoxContainer = $SelectionMenu/PlayerSelection/VBoxContainer/PlayerContainer

@onready var animation_player: AnimationPlayer = $AnimationPlayer



var player_num = 2
var map_selection = 0

var next_scene


func _ready() -> void:
	GlobalGame.refresh_game()

func _set_all_menues_invisible() -> void:
	main.hide()
	selection.hide()
	



#region Main

func _on_tutorial_pressed() -> void:
	next_scene = "res://Scenes/Levels/tutorial.tscn"
	call_deferred("change_scene")


func _on_play_pressed() -> void:
	main.hide()
	selection.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
#endregion

func _on_back_button_pressed() -> void:
	selection.hide()
	main.show()
	
func selection_next() -> void:
	selection.get_child(0).hide()
	selection.get_child(1).show()
	pass
	
func selection_back() -> void:
	selection.get_child(0).show()
	selection.get_child(1).hide()
	pass

func _on_final_play_button_pressed() -> void:
	
	for i in range(player_num):
		var player_loadout = player_container.get_child((2 * i) + 1)
		var player_setup = GlobalGame.PlayerSetup.new()
		
		player_setup.main_sticker = player_loadout.main_sticker
		player_setup.abilities = player_loadout.abilities
		player_setup.character = player_loadout.character
		
		GlobalGame.ready_players.append(player_setup)
				
	next_scene = "res://Scenes/Levels/map_" + str(map_selection) +".tscn"
	call_deferred("change_scene")
	
func show_special() -> void:
	selection.get_child(2).show()
	selection.get_child(1).hide()
	
	
func hide_special() -> void:
	selection.get_child(1).show()
	selection.get_child(2).hide()

	
func pick_map(which_button) -> void:
	map_selection = which_button
	
	var label = $SelectionMenu/MapSelection/VBoxContainer/HBoxContainer/VBoxContainer/MapLabel
	var picture = $SelectionMenu/MapSelection/MapPicture
	
	picture.texture = load("res://Textures/MapPictures/map_" + str(map_selection) + ".PNG")

	
	match map_selection:
		0:
			label.text = "Classic 5x5"
		1:
			label.text = "Chained"
		2:
			label.text = "Chromey"
		3:
			label.text = "Carousel"
		4:
			label.text = "Touchy Subject"
		5:
			label.text = "Lazy River"
		6:
			label.text = "Inertia"
		7:
			label.text = "Just a Big Doughnut"
		8:
			label.text = "Snowflake"
		9:
			label.text = "Islands"

	
func add_player() -> void:
	
	player_num += 1
	
	if player_num > 4:
		player_num = 4
		return
		
		
	var player
	var separator
	
	match player_num:
		
		2:
			player = player_container.get_child(3)
			separator = player_container.get_child(4)
		3:
			player = player_container.get_child(5)
			separator = player_container.get_child(6)
		4:
			player = player_container.get_child(7)
			separator = player_container.get_child(8)
		_:
			return
		

	
	player.show()
	separator.show()
	
	var label = $SelectionMenu/PlayerSelection/VBoxContainer/HBoxContainer/PlayerNumberCounter
	label.text = str(player_num) + "-Player Game"

	
func remove_player() -> void:
	
	
	if player_num <= 1:
		player_num = 1
		return
		
		
	var player
	var separator
	
	match player_num:
		
		2:
			player = player_container.get_child(3)
			separator = player_container.get_child(4)
		3:
			player = player_container.get_child(5)
			separator = player_container.get_child(6)
		4:
			player = player_container.get_child(7)
			separator = player_container.get_child(8)
		_:
			return
			
		
	
	player.hide()
	separator.hide()
	
	player_num -= 1
	
	var label = $SelectionMenu/PlayerSelection/VBoxContainer/HBoxContainer/PlayerNumberCounter
	label.text = str(player_num) + "-Player Game"
	
func increment_win_tiles(amount) -> void:
	
	GlobalGame.tiles_to_win += amount
	
	var tile_label = $SelectionMenu/SpecialRules/HBoxContainer/VBoxContainer/Tiles/Label
	tile_label.text = "TILES TO WIN: " + str(GlobalGame.tiles_to_win)
	
func increment_max_abilities(amount) -> void:
	
	GlobalGame.max_abilities += amount
	
	var ability_label = $SelectionMenu/SpecialRules/HBoxContainer/VBoxContainer/MaxAbilities/Label
	ability_label.text = "MAX ABILITY STICKERS: " + str(GlobalGame.max_abilities)
	
	
func increment_chaos_factor(amount) -> void:
	
	GlobalGame.chaos_factor += amount
	
	var chaos_label = $SelectionMenu/SpecialRules/HBoxContainer/VBoxContainer/Chaos/Label
	chaos_label.text = "CHAOS FACTOR: " + str(GlobalGame.chaos_factor * 100) + "%"
	
func change_scene() -> void:
	animation_player.play("FadeOut")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "FadeOut"):
		get_tree().change_scene_to_file(next_scene)

	
