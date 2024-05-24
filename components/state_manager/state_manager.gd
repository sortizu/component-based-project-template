tool
class_name StateManager extends Component
# ----------------------- DEPENDENCIES ------------------
export (NodePath) var _starting_state_path
onready var starting_state_node: State
var current_state: State
# ----------------------- FUNCTIONS ------------------
# TODO DOCUMENTATION
func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	if not is_connected("child_entered_tree",self,"_on_child_entered"):
		connect("child_entered_tree",self,"_on_child_entered")

# TODO DOCUMENTATION
func _ready():
	if not Engine.editor_hint:
		for child in get_children():
			if child is State:
				child.actor=get_parent()
				child.connect("change_state",self,"change_state")
		starting_state_node = get_node(_starting_state_path)
		change_state(starting_state_node)

# TODO DOCUMENTATION
func change_state(_new_state: State) -> void:
	if current_state:
		current_state.exit_state()
	current_state=_new_state
	current_state.enter_state()

# TODO DOCUMENTATION
func _process(_delta):
	if current_state:
		current_state.state_process(_delta)

# TODO DOCUMENTATION
func _on_child_entered(node:Node):
	if node is State:
		node.actor = get_parent()

# TODO DOCUMENTATION
func _get_configuration_warning() -> String:
	for child in get_children():
		if child is State:
			child.set("actor",get_parent())
		else:
			return "Children of this component should be of type State"
	return ._get_configuration_warning()
