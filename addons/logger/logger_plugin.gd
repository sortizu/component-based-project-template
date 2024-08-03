tool
extends EditorPlugin

var logger: Node

func _enter_tree():
	add_autoload_singleton("Logger","res://addons/logger/logger.gd")
	if not is_connected("scene_changed",self,"on_scene_changed"):
		connect("scene_changed",logger,"on_scene_changed")

func _ready():
	call_deferred("set_dependencies")

func set_dependencies():
	var logger: Node = get_node_or_null("/root/Logger")

func on_scene_changed():
	if logger:
		logger.request_loggers_clear()
