extends CustomTileComponent



func on_action(callable_action: Callable, action_arguments) -> void:
	
	if callable_action.get_method() == "move_column" || callable_action.get_method() == "move_row":

		callable_action.call(action_arguments[0], action_arguments[1])
	
