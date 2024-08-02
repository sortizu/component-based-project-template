tool
extends Node

enum LogDetails {NAME, PATH}
var recent_loggers: Array = []
# Presets
var log_detail: int = LogDetails.NAME

func get_formatted_message(msg: String) -> String:
	return ""

func print_error(msg: String):
	print_error(msg)

func on_scene_changed():
	print("scene changed")
