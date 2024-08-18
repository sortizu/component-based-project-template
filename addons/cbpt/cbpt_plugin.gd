tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("CBPTEventBus","res://addons/cbpt/cbpt_event_bus.gd")


func _exit_tree():
	remove_autoload_singleton("CBPTEventBus")
