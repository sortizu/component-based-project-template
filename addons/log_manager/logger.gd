tool
class_name Logger

# This class provides functionalities to make logs and to control its frequency, order and format.
# Logger can be used as a simple manager of the log process, controlling
# the [log_requester] and showing messages depending on previous requesters and messages.
# Considerations:
# - It is recommendable to instance new [Logger]s using the LogManager autoload.
# - It is not thread safe!

# ENUM DEFINITION

enum LogLevels {INFO=0, WARN=1, ERROR=2}
# List all possible outputs for logs
enum LogOutput {DEBUGGER, OUTPUT, ALL}

# VARIABLES (PRESETS)

var _name: String
var log_level: int = LogLevels.INFO
## TODO DOCUMENTATION
var format: String = "{time} [{lvl}] {msg}"
## TODO DOCUMENTATION
var time_format: String = "YYYY-MM-DD hh:mm:ss"
var log_requester_id: int
var _log_history: Array = []
var _max_log_history: int = 1

## ADITIONAL SETTINGS

# Selected output for [warn] and [error] logs
var high_level_output: int = LogOutput.DEBUGGER

# For custom log validation and managing check: 
# [log_requester]
# [is_log_data_valid]
# [is_formatted_message_valid]

# METHODS

## Setting [Logger] name (used to indentify the logger) and the default [log_level] value to [INFO]
func _init(_new_name: String):
	_name = _new_name
	log_level = LogLevels.INFO

## Requests a log of [INFO] type to [dlog]. Mostly used for giving information about processes on execution.
func info(_msg: String, _format: String = format, _time_format: String = time_format):
	dlog(_msg, LogLevels.INFO, _format, _time_format)

## Requests a log of [WARN] type to [dlog]. Mostly used to notify potential errors.
func warn(_msg: String, _format: String = format, _time_format: String = time_format):
	dlog(_msg, LogLevels.WARN, _format, _time_format)

## Requests a log of [ERROR] type to [dlog]. Mostly used to notify undesired results when executing a process.
func error(_msg: String, _format: String = format, _time_format: String = time_format):
	dlog(_msg, LogLevels.ERROR, _format, _time_format)

## Executes an assert if godot editor is open, otherwise requests a log of [ERROR] type 
func errorb(_msg: String, _format: String = format, _time_format: String = time_format):
	if not is_log_data_valid(_msg, LogLevels.ERROR, _format, _time_format):
		return
	var _fmsg: String = get_formatted_message(_msg, LogLevels.ERROR, _format, _time_format)
	if not is_formatted_message_valid(_fmsg):
		return
	add_to_log_history(_fmsg)
	if not Engine.editor_hint:
		push_error(_fmsg)
		return
	#
	# Please, go down in the stacktrace to reach the faulty code
	#
	assert(false, _fmsg)

## Detailed log method, used for customizable logs
func dlog(_msg: String, _lvl: int, _format: String, _time_format: String):
	if not is_log_data_valid(_msg, _lvl, _format, _time_format):
		return
	var objs: Array = []
	var fmsg: String = get_formatted_message(_msg, _lvl, _format, _time_format)
	if not is_formatted_message_valid(fmsg):
		return
	# Append log to [log_history]
	add_to_log_history(_msg)
	match _lvl:
		LogLevels.INFO:
			print(fmsg)
		LogLevels.WARN:
			match high_level_output:
				LogOutput.OUTPUT:
					print(fmsg)
				LogOutput.DEBUGGER:
					push_warning(fmsg)
				LogOutput.ALL:
					push_warning(fmsg)
					print(fmsg)
		LogLevels.ERROR:
			match high_level_output:
				LogOutput.OUTPUT:
					print(fmsg)
				LogOutput.DEBUGGER:
					push_error(fmsg)
				LogOutput.ALL:
					push_error(fmsg)
					print(fmsg)

## Evaluates if the data passed to [dlog] is valid by checking:
## - Whether the log level satisfies the preset [log_level].
## - Any other validation logic (Overwritting this method on inherited classes).
func is_log_data_valid(_msg: String, _lvl: int, _format: String, _time_format: String) -> bool:
	# The log level ([_lvl]) matches the current [log_level]
	if log_level > _lvl:
		return false
	return true # Add custom validation logic

## Evaluates if the formatted message is valid by checking:
## - It is already in the log history (which only saves recent logs according to [_max_log_history]).
## - Any other validation logic (Overwritting this method on inherited classes).
func is_formatted_message_valid(_fmsg: String):
#	if _log_history.has(_fmsg):
#		return false
	return true  # Add custom validation logic

## Returns a new String based on _msg, but replacing all format codes with
## the respective information.
## format codes: 
## - {msg} -> message
## - {lvl} -> log level
## - {time} -> log time data based on [_time_format]
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

## Available timestamps formats:
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

## Adds a new log to [log_history] array and controls it's
## maximum size using [_max_log_history]
func add_to_log_history(msg: String):
	if _log_history.size() >= _max_log_history:
		_log_history.pop_back()
	_log_history.append(msg)
