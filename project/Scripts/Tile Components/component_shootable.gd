extends CustomTileComponent



func on_action(callable_action: Callable, action_arguments) -> void:
	
	if callable_action.get_method() == "shoot_tile":

		callable_action.call(action_arguments[0])
		interacted.emit()
	
