class_name Logger

# This class provides functionalities to make logs and to control its frequency, order and format.
# Logger can be used as a simple manager of the log process, controlling
# the [log_requesters] and showing messages depending on previous requesters
# and messages. Its recommended to instance new [Logger]s using LogManager autoload.

# ENUM DEFINITION

enum LogLevels {INFO, WARN, ERROR}
enum ValidationConditions {NOT_RECENT_LOGGER, RECENT_LOGGER_ONCE}

# VARIABLES (PRESETS)

var _name: String
var log_level: int = LogLevels.INFO
var format: String
var current_validation_condition: int = ValidationConditions.NOT_RECENT_LOGGER

# For custom logger validation and managing check: 
# [clear_logger]
# [recent_loggers]
# [request_loggers_clear]
# [set_current_logger]
# [LoggerValidationConditions]
# [is_current_valid]
# [is_current_in_recent_loggers]

# METHODS

## TODO DOCUMENTATION
func _init(_new_name: String):
	_name = _new_name

## TODO DOCUMENTATION
func info(msg: String):
	pass

## TODO DOCUMENTATION
func warn(msg: String):
	pass

## TODO DOCUMENTATION
func error(msg: String):
	pass

## Receives a string [msg] with "format codes" used for inserts specific
## information about a received group of objects [objects].
## Format code syntax with multiple objects: [object_index:property_name]
## Format code syntax with a single object: [property_name]
## Message examples:
## "[1:class]: This class has raised an error ([2:path])"
func get_formatted_message(msg: String, objects: Array) -> String:
	var final_msg: String = msg
	var container_start_splits: PoolStringArray = msg.split("[")
	for phrase in container_start_splits:
		if objects.empty():
			break
		phrase = phrase as String
		var raw_format_code: String = phrase.get_slice("]",0)
		var obj_index: int = -1
		var property_name: String
		# Checks which syntax is used in the format code and gets
		# object_index and property_name if possible.
		if raw_format_code.matchn("*:*"):
			# Gets assumed index
			var aindex: String = raw_format_code.get_slice(":",0) # assumed index
			if not aindex.is_valid_integer(): # Wrong syntax used
				continue
			obj_index = int(aindex)
			# Gets property name
			property_name = raw_format_code.get_slice(":",1)
		else:
			property_name = raw_format_code
		# Gets the property owner (objects array)
		var property_value: String
		var object: Object
		if obj_index >= 0:
			object = objects[obj_index]
		else:
			object = objects[0]
		# Checks if the property name exists in the object(s)
		# If it exist, gets the property value
		var property_exist: bool = false
		if not object:
			continue
#		print(raw_format_code)
		for prop_dict in object.get_property_list():
			if property_name == prop_dict["name"]:
				property_exist = true
		if not property_exist:
			continue
		property_value = str(object.get(property_name))
		final_msg = final_msg.replace("[%s]"%raw_format_code,property_value)
	return final_msg

### TODO DOCUMENTATION
#func push_error(msg: String, objects: Array = []):
#	if is_current_valid():
#		printerr(get_formatted_message(msg,objects))
#
### TODO DOCUMENTATION
#func print_error(msg: String, objects: Array = []):
#	if is_current_valid():
#		printerr(get_formatted_message(msg,objects))
#
### TODO DOCUMENTATION
#func print(msg: String, objects: Array = []):
#	if is_current_valid():
#		print(get_formatted_message(msg,objects))
