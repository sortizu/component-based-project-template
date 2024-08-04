tool
extends Entity

func _enter_tree():
	pass

func _ready():
	
	Logger.print_error("[name]: Hola ([filename])",[self])
	Logger.print_error("[name]: Hola ([filename])",[self])
#	print(get_property_list())
