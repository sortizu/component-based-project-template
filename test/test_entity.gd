tool
extends Entity
var thread: Thread = Thread.new()
#var arr: Array = []
func _ready():
	OS.window_minimized= true
	var logger: Logger = LogManager.get_logger("Entity")
	logger.info("Testing this log (%s)"%self.name)
