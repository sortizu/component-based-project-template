extends Node

# Signals

# This signals can be received for any object that wants
# a flexible way to detect this events (e.g. StateManager)
signal physics_process(delta)
signal process(delta)
signal unhandled_input(event)

# METHODS

func _process(delta):
	emit_signal("process", delta)

func _physics_process(delta):
	emit_signal("physics_process", delta)

func _unhandled_input(event):
	emit_signal("unhandled_input", event)
