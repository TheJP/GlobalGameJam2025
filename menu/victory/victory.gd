extends TextureRect


var _level_scene: PackedScene = load("res://level/level.tscn")
var _main_menu_scene: PackedScene = load("res://menu/main_menu/main_menu.tscn")


func _ready() -> void:
	%Play.grab_focus()

	get_viewport().gui_focus_changed.connect(func(_control: Control) -> void: Music.play_sound(Music.Sounds.Menu_hover))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("all_accept"):
		var control := get_viewport().gui_get_focus_owner()
		if not control:
			return
		if control is Button:
			control.button_up.emit()


func _on_back_button_up() -> void:
	_switch_scene(_main_menu_scene)


func _switch_scene(scene: PackedScene) -> void:
	Music.play_sound(Music.Sounds.Menu_click)
	get_tree().change_scene_to_packed(scene)


func _on_play_button_up() -> void:
	# Rotate players for next playthrough
	var device := PlayerInput._controller_to_device[0]
	PlayerInput._controller_to_device.remove_at(0)
	PlayerInput._controller_to_device.append(device)

	Music.play_sound(Music.Sounds.Start_game)
	_switch_scene(_level_scene)


func _on_home_button_up() -> void:
	_switch_scene(_main_menu_scene)
