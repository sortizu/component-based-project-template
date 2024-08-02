tool
extends Node

# TODO DOCUMENTATION

# VARIABLES

enum Formats {DEFAULT, PATH}
enum Positions {BEGIN, END}
var recent_loggers: Array = []
var current_logger: Object setget set_current_logger

# PRESETS

var format: int = Formats.DEFAULT
var position: int = Positions.BEGIN

## TODO DOCUMENTATION
func get_formatted_message(msg: String, logger: Object = current_logger) -> String:
	return ""

## TODO DOCUMENTATION
func print_error(msg: String, logger: Object = current_logger):
	push_error(msg)

## TODO DOCUMENTATION
func on_scene_changed(new_scene: Node):
	recent_loggers.clear()

## TODO DOCUMENTATION
func set_current_logger(new_logger: Object):
	if current_logger:
		recent_loggers.append(current_logger.get_instance_id())
	current_logger = new_logger
