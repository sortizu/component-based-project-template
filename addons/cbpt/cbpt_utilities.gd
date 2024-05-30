tool
extends Node
# This autoload contains some functions needed for internal operations
# of this addon. This is not made to be used for other purposes.
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

## Searches within a source code for all components requested within
## calls to "get_component" and, from this list, returns only the components
## that are missing in the "actor" entity
func get_missing_components_on_entity(source_code:String, actor:Entity, entity_specifier:String)->Array:
	var dependencies_types = []
	var searched_code: String = "get_component("
	if not entity_specifier.empty(): searched_code = entity_specifier + "."+ searched_code
	var splitted_code_array: Array = source_code.split(searched_code)
	var valid_splitted_code:bool=false
	var is_comment: bool = false
	var is_str: bool = false
	var is_declaration: bool = false
	for splitted_code in splitted_code_array:
		splitted_code=splitted_code as String
		if valid_splitted_code and not is_comment and not is_str and not is_declaration:
			var type_name: String = splitted_code.get_slice(")",0)
			if not actor.get_component(type_name,false):
				dependencies_types.append(type_name)
		var nl_index:int=splitted_code.find_last("\n")
		var cm_index:int=splitted_code.find_last("#")
		if nl_index<cm_index:
			is_comment=true
		else:
			is_comment=false
		var quotes = splitted_code.countn("\"")
		is_str = quotes % 2 != 0
		is_declaration = splitted_code.ends_with("func ")
		valid_splitted_code = true
	return dependencies_types

# TODO DOCUMENTATION
func class_name_in_list(name:String)->bool:
	return _node_class_list_script.node_class_list.values().has(name)

# TODO DOCUMENTATION
func class_in_list(node_class):
	return _node_class_list_script.node_class_list.has(node_class)
