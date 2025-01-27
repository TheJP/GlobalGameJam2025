extends Area2D


var _destroyed := false
@onready var collision_shape := $CollisionShape2D

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player_bullet") and not area.is_in_group("fish"):
		return
	if _destroyed:
		return
	_destroyed = true

	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, 0.0), 1)
	tween.tween_callback(func() -> void: queue_free())
	
	# To prevent crashing into it, while it is alredy distroyed and disappearing
	# But wait a short time, otherwise not all collisions might be registered (an for example the shot doesn't get removed)
	var timer := Timer.new()
	timer.wait_time = 0.02
	timer.one_shot = true
	timer.connect("timeout", func() -> void:
		remove_from_group("enemy")
		collision_shape.queue_free()
		timer.queue_free()
	)
	add_child(timer)
	timer.start()
#	remove_from_group("enemy")
#	collision_shape.queue_free()
