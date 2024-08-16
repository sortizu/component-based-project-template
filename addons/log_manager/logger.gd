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
# [is_log_data_valid]

# METHODS

## Setting [Logger] name (used to indentify the logger) and the default [log_level] value to [INFO]
func _init(_new_name: String):
	_name = _new_name
	log_level = LogLevels.INFO

## Request a log of [INFO] type to [dlog]. Mostly used for giving information about processes on execution.
func info(_msg: String):
	dlog(_msg, LogLevels.INFO, format, time_format)

## Request a log of [WARN] type to [dlog]. Mostly used to notify potential errors.
func warn(_msg: String):
	dlog(_msg, LogLevels.WARN, format, time_format)

## Request a log of [ERROR] type to [dlog]. Mostly used to notify undesired results when executing a process.
func error(_msg: String):
	dlog(_msg, LogLevels.ERROR, format, time_format)

## Detailed log method, uses a dictionary to get the data to log.
## Data names: [msg] -> message, [lvl] -> log level, [objs] -> objects to be inserted on log [msg]
func dlog(_msg: String, _lvl: int, _format: String, _time_format: String):
	if is_log_data_valid(_msg, _lvl, _format, _time_format):
		pass
	var objs: Array = []
	var fmsg: String = get_formatted_message(_msg, _lvl, _format, _time_format)
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
func is_log_data_valid(_msg: String, _lvl: int, _format: String, _time_format: String) -> bool:
	# The log level ([_lvl]) matches the current [log_level]
	if log_level > _lvl:
		return false
	return true # Add custom validation logic

## TODO DOCUMENTATION
static func get_formatted_message(_msg: String, _lvl: int, _format: String, _time_format: String) -> String:
	var final_msg: String = _format
	# Creating new message based on [format]
	# Inserting message
	final_msg = final_msg.replace("{msg}",_msg)
	# Inserting time
	if not _time_format.empty():
		final_msg = get_formatted_time_on_msg(final_msg, _time_format)
	# Inserting level
	final_msg = final_msg.replace("{lvl}",LogLevels.keys()[_lvl])
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
