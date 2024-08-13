class_name Logger

# This class provides functionalities to make logs and to control its frequency, order and format.
# Logger can be used as a simple manager of the log process, controlling
# the [log_requester] and showing messages depending on previous requesters and messages.
# Considerations:
# - It is recommendable to instance new [Logger]s using the LogManager autoload.
# - It is not thread safe!

# ENUM DEFINITION

enum LogLevels {INFO=0, WARN=1, ERROR=2}
enum ValidationConditions {NOT_RECENT_LOGGER, RECENT_LOGGER_ONCE}

# VARIABLES (PRESETS)

var _name: String
var log_level: int = LogLevels.INFO
var format: String
var log_requester: Object
var current_validation_condition: int = ValidationConditions.NOT_RECENT_LOGGER

# For custom log validation and managing check: 
# [log_requester]
# [is_valid]

# METHODS

## Setting [Logger] name (used to indentify the logger) and the default [log_level] value to [INFO]
func _init(_new_name: String):
	_name = _new_name
	log_level = LogLevels.INFO

## Request a log of [INFO] type to [dlog]. Mostly used for giving information about processes on execution.
func info(msg: String):
	dlog({"msg":msg,"lvl":LogLevels.INFO})

## Request a log of [WARN] type to [dlog]. Mostly used to notify potential errors.
func warn(msg: String):
	dlog({"msg":msg,"lvl":LogLevels.WARN})

## Request a log of [ERROR] type to [dlog]. Mostly used to notify undesired results when executing a process.
func error(msg: String):
	dlog({"msg":msg,"lvl":LogLevels.ERROR})

## Detailed log method, uses a dictionary to get the data to log.
## Data names: [msg] -> message, [lvl] -> log level, [objs] -> objects to be inserted on log [msg]
func dlog(log_dict: Dictionary):
	if is_valid(log_dict):
		pass
	var objs: Array = []
	if log_dict.has("objs"):
		objs = log_dict["objs"]
	var fmsg: String = get_formatted_message(log_dict["msg"],objs)
	match log_dict["lvl"]:
		LogLevels.WARN:
			push_warning(fmsg)
		LogLevels.ERROR:
			push_error(fmsg)
		_:
			print(fmsg)

## Evaluates if the dictionary passed to [dlog] is valid by checking:
## - Whether it has the necessary information to log.
## - Whether the log level satisfies the preset [log_level].
## - Any other validation logic (Overwritting this method on inherited classes).
func is_valid(log_dict: Dictionary) -> bool:
	# Log dict has all the needed information for logs
	if not log_dict.has("msg"):
		return false
	if log_dict.has("lvl"):
		if not LogLevels.has(log_dict["lvl"]):
			return false
	# The log level ([lvl]) matches the current [log_level]
	if log_level > log_dict["lvl"]:
		return false
	return true

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
