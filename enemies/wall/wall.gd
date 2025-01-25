extends Area2D


var _destroyed := false


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player_bullet") and not area.is_in_group("fish"):
		return
	if _destroyed:
		return
	_destroyed = true

	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, 0.0), 1)
	tween.tween_callback(func() -> void: queue_free())
