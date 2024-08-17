tool
extends Node

# This autoload handles the creation and reutilization
# of [Logger]s. It can be used for any script to get a new Logger
# that can be reutilized in any system context.
# Based on Log4j.

# VARIABLES

# Stores all _loggers returned on [get_logger]
var _loggers: Dictionary = {}
# Stores the last logger returned on [get_logger]
var _last_requested_logger: Logger
# TODO DOCUMENTATION
var default_format: String = "{time} [{lvl}] {msg}"
# TODO DOCUMENTATION
var default_time_format: String = "YYYY-MM-DD hh:mm:ss"

# METHODS

## TODO DOCUMENTATION
func get_logger(name: String) -> Logger:
	var logger: Logger
	if _loggers.has(name):
		logger = _loggers[name]
	else:
		logger = Logger.new(name)
		_loggers[name] = logger
	_last_requested_logger = logger
	return logger

## TODO DOCUMENTATION
func request_clear_loggers():
	_loggers.clear()
