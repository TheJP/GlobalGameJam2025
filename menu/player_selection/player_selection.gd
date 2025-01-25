extends Control


func _ready() -> void:
	PlayerInput.clear_players()


func _process(_delta: float) -> void:
	for just_joined in PlayerInput.get_just_pressed_controllers("button_0"):
		PlayerInput.add_player(just_joined)
	for just_cancelled in PlayerInput.get_just_pressed_controllers("cancel"):
		PlayerInput.remove_player(just_cancelled)

	%DebugText.text = "";
	for player_index in PlayerInput.player_to_controller.size():
		var controller := PlayerInput.player_to_controller[player_index]
		%DebugText.text += "Player %d (Input=%d)\n" % [player_index, controller]
