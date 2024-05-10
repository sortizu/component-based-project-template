tool
class_name State extends Node2D

var actor: Entity

func enter_state():
	pass

func exit_state():
	pass

func state_unhandled_input(_event:InputEvent):
	pass
# TODO DOCUMENTATION
func state_process(_delta):
	pass
# TODO DOCUMENTATION
func _get_configuration_warning() -> String:	
	# Searching new uses of "get_component" method to identify new dependencies
	# to show in editor as warning
	var source_code: String = (get_script() as Script).source_code
	var dependencies_types = []
	var splitted_code_array: Array = source_code.split("actor.get_component(")
	var valid_splitted_code:bool=false
	var is_comment:bool=false
	var is_str:bool=false
	for splitted_code in splitted_code_array:
		splitted_code=splitted_code as String
		if valid_splitted_code and not is_comment and not is_str:
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
		valid_splitted_code = true
	var msg: String
	if len(dependencies_types)>0:
		msg = "This state will require the following components: "
		var index:int = 0
		for type in dependencies_types:
			msg += type as String
			index += 1
			if index<len(dependencies_types):
				msg += ", "
	return msg
