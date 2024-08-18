tool
class_name State extends Node2D
var actor: Entity
# warning-ignore:unused_signal
signal change_state(state_name)

## This method is called when the state is set as [current_state] in the StateManager
func _enter_state():
	pass

## This method is called when the state is replaced as [current_state] in the StateManager
func _exit_state():
	pass

## This method is called (by the [StateManager]) every time an InputEvent
## is triggered
func _state_unhandled_input(_event:InputEvent):
	pass

## This method is called (by the [StateManager]) every frame
func _state_process(_delta):
	pass

## Getting the missing components on actor [Entity] to show in editor as warning
func _get_configuration_warning() -> String:	
	var dependencies_types = GodotAPIHelpers.get_missing_components_on_entity(get_script().source_code,actor,"actor")
	var msg: String
	if dependencies_types:
		var str_list:String=str(dependencies_types)
		msg = "This state will require the following components: " + str_list.substr(1,len(str_list)-2)
	return msg
