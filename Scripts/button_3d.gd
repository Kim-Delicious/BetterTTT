extends StaticBody3D

signal button_pushed


func _ready():
	

	connect("input_event", _on_Button3D_input_event)
	$SubViewport/Button.connect("toggled", _on_Button_toggled)
	$SubViewport/Button.connect("pressed", _on_Button_pressed)
	
	

func _on_Button3D_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$SubViewport/Button.emit_signal("pressed")
			button_pushed.emit()
			$SubViewport/Button.set_pressed(true)
		else:
			$SubViewport/Button.set_pressed(false)

func _on_Button_pressed():
	#print("pressed")
	pass

func _on_Button_toggled(button_pressed):
	#print("toggled " + button_pressed )
	pass
