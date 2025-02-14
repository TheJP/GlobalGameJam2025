extends Control


var _main_menu_scene: PackedScene = load("res://menu/main_menu/main_menu.tscn")


func _ready() -> void:
	# TODO: Play hover sound:
	get_viewport().gui_focus_changed.connect(func(_control: Control) -> void: pass)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("all_menu"):
		_set_pause(not %PauseMenu.visible)

	if Input.is_action_just_pressed("all_accept"):
		var control := get_viewport().gui_get_focus_owner()
		if not control:
			return
		if control is Button:
			control.button_up.emit()


func _switch_scene(scene: PackedScene) -> void:
	# TODO: play click sound
	get_tree().change_scene_to_packed(scene)


func _set_pause(value: bool) -> void:
	%PauseMenu.visible = value
	get_tree().paused = %PauseMenu.visible
	if %PauseMenu.visible:
		%Back.grab_focus()


func _on_back_button_up() -> void:
	_set_pause(false)


func _on_home_button_up() -> void:
	get_tree().paused = false
	_switch_scene(_main_menu_scene)
