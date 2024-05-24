tool
extends Node
#-----------------------------AUTOLOAD VARIABLES-------------------------
# Instance of "node_class_list.gd" to get node_class_list dictionary, intended for exclusive use inside this autoload
var _node_class_list_script = preload("res://addons/cbpt/node_class_list.gd").new()
enum ClassParameterTypes{GDSCRIPTNATIVECLASS, GDSCRIPT, STRING, OTHER}
#-----------------------------AUTOLOAD FUNCTIONS-------------------------

# TODO DOCUMENTATION
func get_name_of_native_class(native_class:GDScriptNativeClass)->String:
	var str_class_name: String = ""
	if native_class in _node_class_list_script.node_class_list.keys():
		str_class_name = _node_class_list_script.node_class_list[native_class]
	else:
		assert(false,"CBPTUtilities: Asked native class doesn't inherit of Node class")
	return str_class_name

# TODO DOCUMENTATION
func get_name_of_custom_class(custom_node_class:GDScript)->String:
	var str_class_name: String = ""
	var source_code: String = custom_node_class.source_code
	str_class_name = source_code.get_slice("class_name",1).get_slice("extends",0).strip_edges()
	return str_class_name

# TODO DOCUMENTATION
func get_node_class_name(node:Node)->String:
	var node_class_name: String = node.get_class()
	var script:Script=node.get_script()
	if script:
		node_class_name=get_name_of_custom_class(script)
	return node_class_name

# TODO DOCUMENTATION
func get_class_parameter_type(node_class)->int:
	if node_class is String:
		return ClassParameterTypes.STRING
	elif node_class is GDScript:
		return ClassParameterTypes.GDSCRIPT
	elif node_class is Object and node_class.get_class()=="GDScriptNativeClass":
		return ClassParameterTypes.GDSCRIPTNATIVECLASS
	return ClassParameterTypes.OTHER

# TODO DOCUMENTATION
func class_name_in_list(name:String)->bool:
	return _node_class_list_script.node_class_list.values().has(name)

# TODO DOCUMENTATION
func class_in_list(node_class):
	return _node_class_list_script.node_class_list.has(node_class)
