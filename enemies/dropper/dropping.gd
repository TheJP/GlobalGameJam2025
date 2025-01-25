class_name Dropping
extends Area2D


@export var fall_speed := 1.0
@export var rotation_speed := 1.0
var _destroyed := false


func _process(delta: float) -> void:
	position += Vector2.DOWN * (fall_speed * delta)
	$Sprite2D.rotate(rotation_speed * delta)


func _on_despawn_timer_timeout() -> void:
	if not _destroyed:
		_destroyed = true
		var tween := create_tween()
		tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, 0), 1.0)
		tween.tween_callback(func() -> void: queue_free())


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("fish") and not _destroyed:
		_destroyed = true
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, 0), 1.5)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property($Sprite2D, "scale", $Sprite2D.scale * 2, 0.7)
		tween.set_parallel(false)
		tween.tween_callback(func() -> void: queue_free())
