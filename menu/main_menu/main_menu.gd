extends TextureRect


var _player_selection_scene: PackedScene = preload("res://menu/player_selection/player_selection.tscn")
var _credits_scene: PackedScene = preload("res://menu/credits/credits.tscn")


func _ready() -> void:
	%Play.grab_focus()

	# TODO: Play hover sound:

	get_viewport().gui_focus_changed.connect(func(_control: Control) -> void: Music.play_sound(Music.Sounds.Menu_hover))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("all_accept"):
		var control := get_viewport().gui_get_focus_owner()
		if not control:
			return
		if control is Button:
			control.button_up.emit()


func _on_play_button_up() -> void:
	_switch_scene(_player_selection_scene)


func _on_credits_button_up() -> void:
	_switch_scene(_credits_scene)


func _switch_scene(scene: PackedScene) -> void:
	# TODO: play click sound
	Music.play_sound(Music.Sounds.Menu_click)
	get_tree().change_scene_to_packed(scene)
