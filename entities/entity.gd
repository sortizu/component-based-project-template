# Add the tool keyword in all the inherited classes of this class
tool
class_name Entity extends Node2D

# TODO DOCUMENTATION
func get_component(component_class,throw_error:bool=true,print_error:bool=true) -> Node:
	var component: Node = null
	# "SAFETY WALL" to filter the correct values for type parameter
	var class_type: int = CBPTUtilities.get_class_parameter_type(component_class)
	if class_type == CBPTUtilities.ClassParameterTypes.OTHER:
		assert(false,"%s: Given parameter 'component_class' is not of a valid type (GDScriptNativeClass, GDScript, String)"%name)
	# Searching the component
	if class_type == CBPTUtilities.ClassParameterTypes.STRING:
		for child in get_children():
			if CBPTUtilities.get_node_class_name(child)==component_class: component = child
	else:
		for child in get_children():
			if child is component_class: component = child
	# Function errors
	if not component and (throw_error or print_error):
		var component_class_name: String
		# Getting node class name
		if class_type==CBPTUtilities.ClassParameterTypes.GDSCRIPT:
			component_class_name = CBPTUtilities.get_name_of_custom_class(component_class)
		elif class_type==CBPTUtilities.ClassParameterTypes.GDSCRIPTNATIVECLASS:
			component_class_name = CBPTUtilities.get_name_of_native_class(component_class)
		else:
			component_class_name = component_class
		var error_msg = "%s: Couldn't find component of type %s"%[name, component_class_name]
		if print_error:
			printerr(error_msg)
		assert(not throw_error,error_msg)
	return component

## Getting the missing components on this entity to show in editor as warning
func _get_configuration_warning() -> String:
	var dependencies_types = CBPTUtilities.get_missing_components_on_entity(get_script().source_code,self,"")
	var msg: String
	if dependencies_types:
		var str_list:String=str(dependencies_types)
		msg = "This entity will require the following components: " + str_list.substr(1,len(str_list)-2)
	return msg
