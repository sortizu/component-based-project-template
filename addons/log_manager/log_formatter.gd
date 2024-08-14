class_name LogFormatter

## TODO DOCUMENTATION

# VARIABLES (PRESETS)

var _default_time_format: String = "YYYY-MM-DD hh:mm:ss"

## TODO DOCUMENTATION
static func get_formatted_message(log_dict: Dictionary) -> String:
	var final_msg: String = log_dict["format"]
	# Creating new message based on [format]
	# Inserting message
	final_msg = final_msg.replace("{msg}",log_dict["msg"])
	# Inserting time
	if log_dict.has("time_format"):
		final_msg = get_formatted_time_on_msg(final_msg, log_dict["time_format"])
	# Inserting level
	final_msg = get_formatted_lvl_on_msg(final_msg, log_dict["lvl"])
	# Inserting objects
	if log_dict.has("objs") and log_dict["objs"] is Array:
		final_msg = get_formatted_objs_on_msg(final_msg, log_dict["objs"])
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
	var final_msg = msg.replace("{time}",time_format)
	var current_datetime: Dictionary = Time.get_datetime_dict_from_system()
	final_msg = final_msg.replace("YYYY",current_datetime["year"])
	final_msg = final_msg.replace("MM",current_datetime["month"])
	final_msg = final_msg.replace("DD",current_datetime["day"])
	final_msg = final_msg.replace("hh",current_datetime["hour"])
	final_msg = final_msg.replace("mm",current_datetime["minute"])
	final_msg = final_msg.replace("ss",current_datetime["second"])
	return final_msg

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
static func get_formatted_lvl_on_msg(msg: String, current_lvl: int) -> String:
	var final_msg: String = msg
	match current_lvl:
		0:
			final_msg = final_msg.replace("{lvl}","INFO")
		1:
			final_msg = final_msg.replace("{lvl}","WARN")
		2:
			final_msg = final_msg.replace("{lvl}","ERROR")
	return final_msg
