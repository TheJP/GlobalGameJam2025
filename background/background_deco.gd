extends Node2D


@export var min_alpha := 0.20
@export var max_alpha := 0.40
@export var min_scale := 0.7
@export var max_scale := 1.4


var _sprites: Array[Texture2D] = [
	preload("res://background/background_deco01.png"),
	preload("res://background/background_deco02.png"),
	preload("res://background/background_deco03.png"),
]
var _fade_tween: Tween


func _ready() -> void:
	var fade_duration := randf_range(10.0, 20.0)
	_fade_tween = create_tween()
	_fade_tween.set_ease(Tween.EASE_IN_OUT)
	_fade_tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, max_alpha), fade_duration)
	_fade_tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, min_alpha), fade_duration)
	_fade_tween.set_loops()
	_fade_tween.pause()

	spawn_deco()
	rotation_degrees = randf_range(0.0, 360.0)
	scale = Vector2.ONE * randf_range(min_scale, max_scale)

	var rotation_duration := randf_range(20.0, 30.0)
	var tween_rotation := create_tween()
	tween_rotation.set_ease(Tween.EASE_IN_OUT)
	tween_rotation.tween_property(self, "rotation_degrees", 360.0, rotation_duration)
	tween_rotation.tween_property(self, "rotation_degrees", 0.0, rotation_duration)
	tween_rotation.set_loops()

	var scale_duration := randf_range(10.0, 20.0)
	var tween_scale := create_tween()
	tween_scale.set_ease(Tween.EASE_IN_OUT)
	tween_scale.tween_property(self, "scale", Vector2.ONE * max_scale, scale_duration)
	tween_scale.tween_property(self, "scale", Vector2.ONE * min_scale, scale_duration)
	tween_scale.set_loops()


func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	if camera:
		var screen_rect := get_viewport_rect()
		var max_dim := maxf(screen_rect.size.x, screen_rect.size.y)
		if global_position.distance_squared_to(camera.get_screen_center_position()) > (2 * max_dim) * (2 * max_dim):
			print("max reached")
			spawn_deco()


func spawn_deco() -> void:
	$Sprite2D.texture = _sprites.pick_random()

	_fade_tween.pause()
	$Sprite2D.modulate = Color($Sprite2D.modulate, 0.0)
	var tween_fade := create_tween()
	tween_fade.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, max_alpha), 3.0)
	tween_fade.tween_callback(func() -> void: _fade_tween.play())

	var camera := get_viewport().get_camera_2d()
	if camera:
		var screen_rect := get_viewport_rect()
		global_position = camera.get_target_position() + \
			Vector2.DOWN * screen_rect.size.y * randf_range(-1, 1) + \
			Vector2.RIGHT * screen_rect.size.x * randf_range(-1, 1)


func start_fade_animation() -> void:
	_fade_tween.play()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	spawn_deco()
