tool
extends Entity

func _enter_tree():
	pass

func _ready():
	var logger: Logger = LogManager.get_logger("Entity")
	logger.info("Hola")
