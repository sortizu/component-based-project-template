tool
class_name StateManager extends Component

func _enter_tree() -> void:
# warning-ignore:return_value_discarded
	connect("child_entered_tree",self,"_on_child_entered")

func _on_child_entered(node:Node):
	if node is State:
		node.actor = get_parent()

func _get_configuration_warning() -> String:
	for child in get_children():
		if child is State:
			child.actor = get_parent()
	return ""
