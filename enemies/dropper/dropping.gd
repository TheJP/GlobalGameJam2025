class_name Dropping
extends CharacterBody2D


@export var fall_speed := 1.0
@export var rotation_speed := 1.0
var _destroyed := false


func _physics_process(delta: float) -> void:
	var position_change := Vector2.DOWN * (fall_speed * delta)
	# collision is ignored here, as collider_got_hit gets called when the boat moves. For other collision, e.g. removing the Dropping when it hits the ground would still need to be done here.
	var collision := move_and_collide(position_change)
	$Sprite2D.rotate(rotation_speed * delta)


func collider_got_hit(collision: KinematicCollision2D, collision_object: CollisionObject2D) -> void:
	if collision_object.is_in_group("boat") and not _destroyed:
		_destroyed = true
		collision_layer = 0
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, 0), 1.5)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property($Sprite2D, "scale", $Sprite2D.scale * 1.5, 0.7)
		tween.set_parallel(false)
		tween.tween_callback(func() -> void: queue_free())
	elif collision_object.is_in_group("player_bullet") and not _destroyed:
		_destroyed = true
		collision_layer = 0
		_destroy()


func _on_despawn_timer_timeout() -> void:
	if not _destroyed:
		_destroyed = true
		_destroy()



func _destroy() -> void:
	_destroyed = true
	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, 0), 0.3)
	tween.tween_callback(func() -> void: queue_free())
