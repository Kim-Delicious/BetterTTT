extends StaticBody3D

signal button_pushed


func _ready():
	connect("input_event", _on_Button3D_input_event)

	
	

func _on_Button3D_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$SubViewport/Button.emit_signal("pressed")
			button_pushed.emit()
			$SubViewport/Button.set_pressed(true)
		else:
			$SubViewport/Button.set_pressed(false)
