tool
extends State

func _state_unhandled_input(_event: InputEvent):
	if Input.is_key_pressed(KEY_SPACE):
		print("CHANGING")
		emit_signal("change_state","TestState2")
