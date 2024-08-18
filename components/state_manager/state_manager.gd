tool
class_name StateManager extends Component

# VARIABLES

export(int,"Physics Process","Process") var processing_type: int = 1
export var unhandled_input_event: bool = false

# DEPENDENCIES

export (NodePath) var _starting_state_path
onready var starting_state_node: State
var current_state: State setget set_current_state

# METHODS

## Connects [_on_child_entered] method to [child_entered_tree] signal
func _enter_tree() -> void:
	match processing_type:
		0:
			# warning-ignore:return_value_discarded
			if not CBPTEventBus.is_connected("physics_process",self,"_custom_process"):
				CBPTEventBus.connect("physics_process",self,"_custom_process")
		1:
			# warning-ignore:return_value_discarded
			if not CBPTEventBus.is_connected("process",self,"_custom_process"):
				CBPTEventBus.connect("process",self,"_custom_process")
	if unhandled_input_event and not CBPTEventBus.is_connected("unhandled_input",self,"_custom_unhandled_input"):
		# warning-ignore:return_value_discarded
		CBPTEventBus.connect("unhandled_input",self,"_custom_unhandled_input")
	# warning-ignore:return_value_discarded
	if not is_connected("child_entered_tree",self,"_on_child_entered"):
		connect("child_entered_tree",self,"_on_child_entered")

## Updates the [actor] variable on each child of type [State], and connect the signal
## [change_state] to the method called [change_state]
func _ready():
	if Engine.editor_hint:
		return
#	for child in get_children():
#		if child is State:
#			child.actor = get_parent()
#			child.connect("change_state",self,"change_state")
	starting_state_node = get_node(_starting_state_path)
	set_current_state(starting_state_node)

## Searches for a state in the children of this StateManager using
## a its name in the scene hierarchy, when found, it is selected as
## [current_state]
func change_state(_state_name: String) -> void:
	for child in get_children():
		if not child is State:
			continue
		if child.name == _state_name:
			set_current_state(child)
			break

## Calls the [_state_process] method in [current_state]
func _custom_process(_delta):
	if current_state:
		current_state._state_process(_delta)

## Calls the [_state_unhandled_input] method in [current_state]
func _custom_unhandled_input(event):
	if current_state:
		current_state._state_unhandled_input(event)

## Sets the actor variable (entity parent of this component)
## to any new child of type [State]
func _on_child_entered(_node: Node):
	if _node is State:
		_node.actor = get_parent()
		if not _node.is_connected("change_state",self,"change_state"):
			# warning-ignore:return_value_discarded
			_node.connect("change_state",self,"change_state")

## Shows a warning message in editor when a child isn't of type [State]
func _get_configuration_warning() -> String:
	for child in get_children():
		if not child is State:
			return "Children of this component should be of type State"
	return ._get_configuration_warning()

## Sets a new state to [current_state], calling [_exit_state] in the previous state
## and [_enter_state] on the new one.
func set_current_state(_new_state: State):
	if current_state:
		current_state._exit_state()
	current_state=_new_state
	current_state._enter_state()
