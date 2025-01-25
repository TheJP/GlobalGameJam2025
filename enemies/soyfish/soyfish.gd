class_name Soyfish
extends Area2D


@export var shoot_range := 1700.0
@export var rotation_speed := 0.1


var _destroyed := false
var _boat_bubble: BoatBubble
var _bullet_scene: PackedScene = preload("res://enemies/soyfish/sofish_bullet.tscn")


func _ready() -> void:
	_boat_bubble = get_tree().get_first_node_in_group("fish")


func _process(delta: float) -> void:
	if _boat_bubble:
		var rotation_goal := _boat_bubble.get_bubble_centre().angle_to_point(global_position)
		var difference := angle_difference(rotation, rotation_goal)
		if abs(difference) <= rotation_speed * delta:
			rotation = rotation_goal
		else:
			rotation += sign(difference) * rotation_speed * delta


func _on_shoot_timer_timeout() -> void:
	if _destroyed:
		return

	if _boat_bubble:
		if global_position.distance_squared_to(_boat_bubble.global_position) > shoot_range * shoot_range:
			return

	var bullet: SoyfishBullet = _bullet_scene.instantiate()
	bullet.target = _boat_bubble
	bullet.global_position = $BulletSpawner.global_position
	bullet.global_rotation = global_rotation
	get_parent().add_child(bullet)


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player_bullet") and not area.is_in_group("fish"):
		return
	if _destroyed:
		return
	_destroyed = true

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "scale", $Sprite2D.scale * 0.7, 0.5)
	tween.tween_property($Sprite2D, "modulate", Color($Sprite2D.modulate, 0), 0.5)
	tween.set_parallel(false)
	tween.tween_callback(func() -> void: queue_free())
