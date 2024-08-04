tool
extends EditorPlugin

func _enter_tree() -> void:
	# TODO DOCUMENTATION
	add_autoload_singleton("GodotAPIHelpers","res://addons/godot_api_helpers/godot_api_helpers.gd")

func _exit_tree():
	remove_autoload_singleton("GodotAPIHelpers")
