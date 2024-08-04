# Add the tool keyword in all the inherited classes of this class
tool
class_name Entity extends Node2D

# TODO DOCUMENTATION
func get_component(component_class) -> Node:
	return GodotAPIHelpers.get_component_on_entity(self,component_class)

## Getting the missing components on this entity to show in editor as warning
func _get_configuration_warning() -> String:
	var dependencies_types = GodotAPIHelpers.get_missing_components_on_entity(get_script().source_code,self,"")
	var msg: String
	if dependencies_types:
		var str_list:String=str(dependencies_types)
		msg = "This entity will require the following components: " + str_list.substr(1,len(str_list)-2)
	return msg
