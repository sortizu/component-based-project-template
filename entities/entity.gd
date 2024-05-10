# Add the tool keyword in all the inherited classes of this class
tool
class_name Entity extends Node2D

func get_component(type,throw_error:bool=true) -> Node:
	var component: Node = null
	for child in get_children():
		child = child as Node
		if type is String:
			if child.get_class() == type:
				component=child
				break
		elif child is type:
			component=child
			break
	if not component and throw_error:
		if type is String:
			printerr(name+"("+get_class()+"): Couldn't find component of type "+type)
			assert(not throw_error,"Error trying to find "+str(type))
		else:
			var type_class_name = type.source_code.get_slice("class_name",1).get_slice("extends",0).replace(" ","")
			printerr(name+"("+get_class()+"): Couldn't find component of type "+type_class_name)
			assert(not throw_error,name+"("+get_class()+"): Error trying to find "+type_class_name)
	return component
