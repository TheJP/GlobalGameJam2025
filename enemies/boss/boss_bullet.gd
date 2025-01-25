class_name BossBullet
extends Area2D


@export var fly_speed := 50.0
@export var wavyness := 1.0
@export var rotation_speed := 10.0
var direction := Vector2.LEFT


var _destroyed := false
var _random_speed := 0.0
var _spawn_time := 0.0


func _ready() -> void:
	direction = direction.normalized()
	_random_speed = randf_range(-1.0, 1.0) * (fly_speed * 0.2)
	_spawn_time = Time.get_ticks_msec()


func _process(delta: float) -> void:
	position += direction * ((fly_speed + _random_speed) * delta)
	var perpendicular := Vector2(direction.y, -direction.x)
	position += perpendicular * (sin((Time.get_ticks_msec() - _spawn_time) / 1000.0) * wavyness)
	$Sprite2D.rotate(rotation_speed * delta)


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("fish") and not area.is_in_group("player_bullet"):
		return
	if _destroyed:
		return
	_destroyed = true;

	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.05)
	tween.tween_callback(func() -> void: queue_free())


func _on_despawn_timer_timeout() -> void:
	queue_free()
