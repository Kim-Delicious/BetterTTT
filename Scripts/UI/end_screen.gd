extends TextureRect


@onready var winner_label: Label = $HBoxContainer/VBoxContainer/Winner


signal next_button_pushed
signal screen_landed


func _on_continue_button_pressed() -> void:
	next_button_pushed.emit()

func on_landed() -> void:
	print("landed")
	screen_landed.emit()
