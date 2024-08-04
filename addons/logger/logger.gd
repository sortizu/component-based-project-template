tool
extends Node

# This autoload provides functionalities to make 
# logs and to control its frequency, order and format.
# Logger can be used as a simple manager of the log process, controlling
# the log requesters (loggers) and showing messages depending on previous loggers.
# For custom logger validation and managing check: 
# [clear_logger]
# [recent_loggers]
# [request_loggers_clear]
# [set_current_logger]
# [LoggerValidationConditions]
# [is_current_valid]
# [is_current_in_recent_loggers]

# VARIABLES

# Stores the instance id of current_logger
var recent_loggers: Array = []
# Stores the current object that calls [print] ot [print_error]
# It should be set by the logger itself.
var current_logger: Object setget set_current_logger
# Cleans recent loggers on scene change
var clear_loggers: bool = true # Editor only

# PRESETS

enum LoggerValidationConditions {NOT_RECENT_LOGGER, RECENT_LOGGER_ONCE}
var current_validation_condition: int = LoggerValidationConditions.NOT_RECENT_LOGGER

# METHODS

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

## TODO DOCUMENTATION
func push_error(msg: String, objects: Array = []):
	if is_current_valid():
		printerr(get_formatted_message(msg,objects))

## TODO DOCUMENTATION
func print_error(msg: String, objects: Array = []):
	if is_current_valid():
		printerr(get_formatted_message(msg,objects))

## TODO DOCUMENTATION
func print(msg: String, objects: Array = []):
	if is_current_valid():
		print(get_formatted_message(msg,objects))

## TODO DOCUMENTATION
func is_current_valid() -> bool:
	match current_validation_condition:
		LoggerValidationConditions.NOT_RECENT_LOGGER:
			return not is_current_in_recent_loggers()
		LoggerValidationConditions.RECENT_LOGGER_ONCE:
			return is_current_in_recent_loggers()
	# Add more validation logic
	return true

## TODO DOCUMENTATION
func is_current_in_recent_loggers() -> bool:
	if current_logger:
		return recent_loggers.has(current_logger.get_instance_id())
	return false

## TODO DOCUMENTATION
func request_loggers_clear():
	if clear_loggers:
		recent_loggers.clear()

## TODO DOCUMENTATION
func set_current_logger(new_logger: Object):
	if new_logger:
		recent_loggers.append(new_logger.get_instance_id())
	current_logger = new_logger
