class_name TimeEndDisplay
extends Label


func _ready() -> void:

	var time := ScoreManager.finish_current_run()
	text = ("Time: %.2f" % time) + "s"
