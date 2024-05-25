tool
class_name State extends Node2D
var actor: Entity
# warning-ignore:unused_signal
signal change_state(new_state)
# TODO DOCUMENTATION
func enter_state():
	pass
# TODO DOCUMENTATION
func exit_state():
	pass
# TODO DOCUMENTATION
func state_unhandled_input(_event:InputEvent):
	pass
# TODO DOCUMENTATION
func state_process(_delta):
	pass
## Getting the missing components on actor entity to show in editor as warning
func _get_configuration_warning() -> String:	
	var dependencies_types = CBPTUtilities.get_missing_components_on_entity(get_script().source_code,actor,"actor")
	var msg: String
	if dependencies_types:
		var str_list:String=str(dependencies_types)
		msg = "This state will require the following components: " + str_list.substr(1,len(str_list)-2)
	return msg
