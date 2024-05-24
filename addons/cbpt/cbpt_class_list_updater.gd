extends HTTPRequest

func _ready() -> void:
	var URL = "https://docs.godotengine.org/en/3.5/classes/index.html"
	connect("request_completed", self, "_http_request_completed")
	print("ECS - Class list updater: Requesting class information to Godot Docs...")
	var error = request(URL)
	if error != OK:
		push_error("ECS - Class list updater: Can't connect to Godot docs to update the class list")

func _http_request_completed(result, response_code, headers, body:PoolByteArray):
	print("ECS - Class list updater: Godot Docs response received")
	# Variables definition
	var xml_parser: XMLParser = XMLParser.new()
	var wrapper_node_name: String = ""
	var classes_wrapper_opened: bool = false
	var class_list_opened: bool = false
	var class_array: Array = []
	# Openning the html body 
	xml_parser.open_buffer(body)
	print("ECS - Class list updater: Parsing HTML...")
	# Iterating over html tags and adding the node classes in class_array
	while xml_parser.read() == OK:
		var id_value = xml_parser.get_named_attribute_value_safe("id")
		var node_name: String = ""
		var node_type: int = xml_parser.get_node_type()
		if node_type == XMLParser.NODE_ELEMENT or node_type == XMLParser.NODE_ELEMENT_END:
			node_name = xml_parser.get_node_name()
		if classes_wrapper_opened and wrapper_node_name == node_name:
			classes_wrapper_opened = false
			break
		if id_value == "nodes":
			classes_wrapper_opened = true
			wrapper_node_name = node_name
		if classes_wrapper_opened:
			if not class_list_opened:
				class_list_opened = node_name == "ul"
				continue
			if xml_parser.get_node_type()==XMLParser.NODE_TEXT:
				class_array.append(xml_parser.get_node_data())
	# Iterating over class_array and opening the file to store the class dictionary
	var file = File.new()
	file.open("res://addons/ecs/node_class_list.gd",File.WRITE)
	file.store_line("var class_list: Dictionary = {")
	print("ECS - Class list updater: Saving node classes...")
	for index in len(class_array):
		var node_class: String = class_array[index]
		var new_line: String = "%s:\"%s\"" % [node_class,node_class]
		if index < len(class_array)-1:
			new_line+=","
		file.store_line(new_line)
	file.store_line("}")
	file.close()
	print("ECS - Class list updater: Class list updated (%s classes updated)"%len(class_array))
