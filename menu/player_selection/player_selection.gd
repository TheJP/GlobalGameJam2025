extends Control


## Time in seconds for which players have to hold down the "A" button to start the game.
@export var hold_to_start_duration := 3.0
var level_scene: PackedScene = preload("res://level/level.tscn")


var _start_hold_time := 0.0
var _started := false


func _ready() -> void:
	PlayerInput.clear_players()


func _process(delta: float) -> void:
	for just_joined in PlayerInput.get_just_pressed_controllers("button_0"):
		PlayerInput.add_player(just_joined)
	for just_cancelled in PlayerInput.get_just_pressed_controllers("cancel"):
		PlayerInput.remove_player(just_cancelled)

	if PlayerInput.player_to_controller.size() == 2:
		var pressed := false
		for controller in PlayerInput.player_to_controller:
			if PlayerInput.is_controller_pressed(controller, "button_0"):
				pressed = true
		if pressed:
			_start_hold_time += delta
		else:
			_start_hold_time = 0.0
		if _start_hold_time >= hold_to_start_duration and not _started:
			get_tree().change_scene_to_packed(level_scene)
			_started = true


	%DebugText.text = "";
	for player_index in PlayerInput.player_to_controller.size():
		var controller := PlayerInput.player_to_controller[player_index]
		%DebugText.text += "Player %d (Input=%d)\n" % [player_index, controller]
	if PlayerInput.player_to_controller.size() >= 2:
		var duration: float = min(_start_hold_time, hold_to_start_duration)
		var filled := "#".repeat(ceil(10.0 * (duration / hold_to_start_duration)))
		var spaces := " ".repeat(floor(10.0 * (1.0 - duration / hold_to_start_duration)))
		%DebugText.text += "[" + filled + spaces + "]"
