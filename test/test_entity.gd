tool
extends Entity
var thread: Thread = Thread.new()
#var arr: Array = []
func _ready():
	OS.window_minimized= true
	var start_time: int = Time.get_ticks_usec()
#	thread.start(self,"print_loop",100000)
	var logger: Logger = LogManager.get_logger("Entity")
	logger.info("Testing this log ({name})",[self])
#	thread.wait_to_finish()
	print("Log duration: %f seconds"%((Time.get_ticks_usec()-start_time)/100000.0))

func print_loop(loops: int):
	var logger: Logger = LogManager.get_logger("Entity")
	var arr: Array = []
	for i in range(loops):
#	while true:
#		logger.info("Testing this log ({name})",[self])
#		var newvar = Reference.new()
		arr.append(1)
#		arr.append({"one":1})
#		arr.append(Reference.new())
#		arr.append(Node.new())
#		continue
#		print("Testing this log ({name})")
	print("finished"+str(arr.size()))
