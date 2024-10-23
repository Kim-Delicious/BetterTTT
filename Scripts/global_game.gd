extends Node

var ready_players: Array = []

var tiles_to_win : int = 5:
	set(new_value):
		tiles_to_win = clamp(new_value, 3, 9)
		
var max_abilities: int = 2:
	set(new_value):
		max_abilities = clamp(new_value, 0, 4)
		
var chaos_factor : float = 0.0: # Percentage
	set(new_value):
		chaos_factor = clamp(new_value, 0.0, 1.0)
	
	
func refresh_game() -> void:
	
	ready_players.clear()
	tiles_to_win = 5
	
class PlayerSetup:
	
	var character
	var main_sticker
	var abilities: Array
	
