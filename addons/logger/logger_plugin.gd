tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("Logger","res://addons/logger/logger_plugin.gd")
	connect("scene_changed",self,"on_scene_changed")

#func _ready():
#	var logger: Node = get_node_or_null("/root/Logger")
#	if logger:
#		connect("scene_changed",logger,"on_scene_changed")
#		print("hola")

func on_scene_changed(node: Node):
	print(node)
