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
func info(msg: String):
	dlog({"msg":msg, "lvl":LogLevels.INFO, "format":format, "time_format": time_format})

## Request a log of [WARN] type to [dlog]. Mostly used to notify potential errors.
func warn(msg: String):
	dlog({"msg":msg,"lvl":LogLevels.WARN, "format":format, "time_format": time_format})

## Request a log of [ERROR] type to [dlog]. Mostly used to notify undesired results when executing a process.
func error(msg: String):
	dlog({"msg":msg,"lvl":LogLevels.ERROR, "format":format, "time_format": time_format})

## Detailed log method, uses a dictionary to get the data to log.
## Data names: [msg] -> message, [lvl] -> log level, [objs] -> objects to be inserted on log [msg]
func dlog(log_dict: Dictionary):
	if is_valid(log_dict):
		pass
	var objs: Array = []
	if log_dict.has("objs"):
		objs = log_dict["objs"]
	var fmsg: String = LogFormatter.get_formatted_message(log_dict)
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
	if not log_dict.has("format"):
		return false
	if not log_dict.has("msg"):
		return false
	if log_dict.has("lvl"):
		if not LogLevels.has(log_dict["lvl"]):
			return false
	# The log level ([lvl]) matches the current [log_level]
	if log_level > log_dict["lvl"]:
		return false
	return true
