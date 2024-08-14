tool
extends Entity

func _enter_tree():
	pass

func _ready():
	OS.window_minimized= true
	var logger: Logger = LogManager.get_logger("Entity")
	var start_time: int = Time.get_ticks_usec()
	for i in range(100):
		logger.info("Testing this log ({name})",[self])
	print("Log duration: %f microseconds"%((Time.get_ticks_usec()-start_time)/100000.0))
