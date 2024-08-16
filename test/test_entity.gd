tool
extends Entity
var thread: Thread = Thread.new()

func _ready():
	OS.window_minimized= true
	var logger: Logger = LogManager.get_logger("Entity")
	var start_time: int = Time.get_ticks_usec()
	for i in range(10):
		logger.info("Testing this log (%s)"%self.name)
	print("Log duration: %f seconds"%((Time.get_ticks_usec()-start_time)/1000000.0))
