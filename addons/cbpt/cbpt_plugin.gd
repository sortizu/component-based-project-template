tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("CBPTUtilities","res://addons/cbpt/cbpt_utilities.gd")
