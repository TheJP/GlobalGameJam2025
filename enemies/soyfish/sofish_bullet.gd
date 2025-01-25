class_name SoyfishBullet
extends Area2D


@export var fly_speed := 200.0
@export var rotation_speed := 0.1
var target: BoatBubble


var _destroyed := false


func _process(delta: float) -> void:
	if _destroyed:
		return
	if target:
		var rotation_goal := target.get_bubble_centre().angle_to_point(global_position)
		var difference := angle_difference(rotation, rotation_goal)
		if abs(difference) <= rotation_speed * delta:
			rotation = rotation_goal
		else:
			rotation += sign(difference) * rotation_speed * delta
	global_position += Vector2(-cos(rotation), -sin(rotation)) * (fly_speed * delta)


func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player_bullet") and not area.is_in_group("fish"):
		return
	if _destroyed:
		return
	_destroyed = true

	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, 0.0), 0.1)
	tween.tween_callback(func() -> void: queue_free())
