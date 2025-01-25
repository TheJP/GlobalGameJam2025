class_name Boss
extends Node2D


@export var swim_speed := 10.0
@export var max_health := 100.0
@export var min_spawn_interval := 0.0
@export var max_spawn_interval := 10.0
@export var shoot_range := 2000.0
var health := max_health


var _boat: Boat
var _boat_fish: BoatBubble
var _float_tween: Tween
var _boss_bullet_scene: PackedScene = preload("res://enemies/boss/boss_bullet.tscn")
var _next_bullet := 0.0


func _ready() -> void:
	var fish := get_tree().get_first_node_in_group("fish")
	if fish:
		_boat = fish.get_parent()
		_boat_fish = fish
	_float_tween = create_tween()
	_float_tween.set_ease(Tween.EASE_IN_OUT)
	_float_tween.set_trans(Tween.TRANS_SINE)
	_float_tween.tween_property($Body, "position", $Body.position + Vector2.DOWN * 100.0, 3.0)
	_float_tween.tween_property($Body, "position", $Body.position, 3.0)
	_float_tween.set_loops()


func _process(delta: float) -> void:
	if _boat:
		var y_distance: float = _boat_fish.get_bubble_centre().y - global_position.y
		if abs(y_distance) <= swim_speed * delta:
			global_position.y += y_distance
		else:
			global_position.y += sign(y_distance) * swim_speed * delta

		if Time.get_ticks_msec() >= _next_bullet:
			if global_position.distance_squared_to(_boat.global_position) <= shoot_range * shoot_range:
				var bullet_position := global_position
				var bullet: BossBullet = _boss_bullet_scene.instantiate()
				bullet.global_position = bullet_position
				bullet.direction = (_boat_fish.get_bubble_centre() - bullet_position).normalized()
				get_parent().add_child(bullet)
			_next_bullet = randf_range(min_spawn_interval, max_spawn_interval) * 1000 + Time.get_ticks_msec()


func _on_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		health = min(0.0, health - 5.0)
		%Health.update_health(health / max_health)
	if health <= 0.0:
		queue_free() # TODO: Animation
