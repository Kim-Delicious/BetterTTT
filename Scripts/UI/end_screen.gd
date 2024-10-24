extends TextureRect


@onready var winner_label: Label = $HBoxContainer/VBoxContainer/Winner


signal next_button_pushed



func _on_continue_button_pressed() -> void:
	next_button_pushed.emit()
