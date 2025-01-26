extends TextureRect


var _player_selection_scene: PackedScene = preload("res://menu/player_selection/player_selection.tscn")


func _ready() -> void:
	%Play.grab_focus()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("all_accept"):
		print("accept")
		var control := get_viewport().gui_get_focus_owner()
		if not control:
			return
		if control is Button:
			print("up")
			control.button_up.emit()


func _on_play_button_up() -> void:
	get_tree().change_scene_to_packed(_player_selection_scene)


func _on_credits_button_up() -> void:
	pass # Replace with function body.
