extends Node

var _last_time: float = 0
var _current_time: float = -1
var is_paused: bool = false


func start_new_run() -> void:
	_current_time = 0
	is_paused = false


func finish_current_run() -> float:
	_last_time = _current_time
	_current_time = -1
	return _last_time


func cancel_current_run() -> void:
	_current_time = -1


func pause_current_run() -> void:
	is_paused = true


func resume_current_run() -> void:
	is_paused = false


func set_pause(value: bool) -> void:
	if value:
		pause_current_run()
	else:
		resume_current_run()


func get_current_time() -> float:
	return _current_time


func get_last_time() -> float:
	return _last_time


func is_running() -> bool:
	return _current_time >= 0 and !is_paused


func _process(delta: float) -> void:
	if !is_running():
		return
	_current_time += delta
	print("Current time: ", _current_time)
