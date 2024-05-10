tool
class_name Component extends Node2D

# TODO DOCUMENTATION
var updated_class_name: String

func _enter_tree() -> void:
	# Updating class_name
	var source_code: String = (get_script() as Script).source_code
	updated_class_name = source_code.get_slice("class_name",1).get_slice("extends",0).replace(" ","")
	# ...
	var parent = get_parent()
	if not(parent is Entity):
		printerr(name+": The parent of this component must be a node of type \"Entity\"")

func _get_configuration_warning() -> String:
	var parent = get_parent()
	if not(parent is Entity):
		return "The parent of this component must be a node of type \"Entity\""
	else:
		return ""

func get_class():
	if updated_class_name.empty():
		return .get_class()
	else:
		return updated_class_name
