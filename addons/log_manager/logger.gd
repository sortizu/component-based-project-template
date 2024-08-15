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
var format: String = "{time} [{lvl}] {msg}"
var time_format: String = "YYYY-MM-DD hh:mm:ss"
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
func info(_msg: String, _objs: Array):
	dlog(_msg, _objs, LogLevels.INFO, format, time_format)

## Request a log of [WARN] type to [dlog]. Mostly used to notify potential errors.
func warn(_msg: String, _objs: Array):
	dlog(_msg, _objs, LogLevels.WARN, format, time_format)

## Request a log of [ERROR] type to [dlog]. Mostly used to notify undesired results when executing a process.
func error(_msg: String, _objs: Array):
	dlog(_msg, _objs, LogLevels.ERROR, format, time_format)

## Detailed log method, uses a dictionary to get the data to log.
## Data names: [msg] -> message, [lvl] -> log level, [objs] -> objects to be inserted on log [msg]
func dlog(_msg: String, _objs: Array, _lvl: int, _format: String, _time_format: String):
	if is_log_data_valid(_msg, _objs, _lvl, _format, _time_format):
		pass
	var objs: Array = []
	var fmsg: String = get_formatted_message(_msg, _objs, _lvl, _format, _time_format)
	match _lvl:
		LogLevels.WARN:
			push_warning(fmsg)
		LogLevels.ERROR:
			push_error(fmsg)
		LogLevels.INFO:
			print(fmsg)

## Evaluates if the data passed to [dlog] is valid by checking:
## - Whether the log level satisfies the preset [log_level].
## - Any other validation logic (Overwritting this method on inherited classes).
func is_log_data_valid(_msg: String, _objs: Array, _lvl: int, _format: String, _time_format: String) -> bool:
	# The log level ([_lvl]) matches the current [log_level]
	if log_level > _lvl:
		return false
	return true # Add custom validation logic

## TODO DOCUMENTATION
static func get_formatted_message(_msg: String, _objs: Array, _lvl: int, _format: String, _time_format: String) -> String:
	var final_msg: String = _format
	# Creating new message based on [format]
	# Inserting message
	final_msg = final_msg.replace("{msg}",_msg)
	# Inserting time
	if not _time_format.empty():
		final_msg = get_formatted_time_on_msg(final_msg, _time_format)
	# Inserting level
	final_msg = final_msg.replace("{lvl}",LogLevels.keys()[_lvl])
	# Inserting objects
	if not _objs.empty():
		final_msg = get_formatted_objs_on_msg(final_msg, _objs)
	return final_msg

## Available timestamps:
## - YYYY
## - MM
## - DD
## - hh
## - mm
## - ss
static func get_formatted_time_on_msg(msg: String, time_format: String) -> String:
	if not "{time}" in msg:
		return msg
	msg = msg.replace("{time}",time_format)
	var current_datetime: Dictionary = Time.get_datetime_dict_from_system()
	msg = msg.replace("YYYY",current_datetime["year"])
	msg = msg.replace("MM",current_datetime["month"])
	msg = msg.replace("DD",current_datetime["day"])
	msg = msg.replace("hh",current_datetime["hour"])
	msg = msg.replace("mm",current_datetime["minute"])
	msg = msg.replace("ss",current_datetime["second"])
	return msg

## Receives a string [msg] with "format codes" used for inserts specific
## information about a received group of objects [objects].
## Format code syntax with multiple objects: {object_index:property_name}
## Format code syntax with a single object: {property_name}
## Message examples:
## "{1:class}: This class has raised an error ({2:path})"
static func get_formatted_objs_on_msg(msg: String, objects: Array) -> String:
	var final_msg: String = msg
	var container_start_splits: PoolStringArray = msg.split("{")
	for phrase in container_start_splits:
		if objects.empty():
			break
		phrase = phrase as String
		var raw_format_code: String = phrase.get_slice("}",0)
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
		for prop_dict in object.get_property_list():
			if property_name == prop_dict["name"]:
				property_exist = true
		if not property_exist:
			continue
		property_value = str(object.get(property_name))
		final_msg = final_msg.replace("{"+raw_format_code+"}",property_value)
	return final_msg
