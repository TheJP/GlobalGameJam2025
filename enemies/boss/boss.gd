class_name Boss
extends Node2D


@export var swim_speed := 10.0
@export var max_health := 100.0
var health := max_health / 3.0


var _boat: Boat
var _float_tween: Tween


func _ready() -> void:
	var fish := get_tree().get_first_node_in_group("fish")
	if fish:
		_boat = fish.get_parent()
	_float_tween = create_tween()
	_float_tween.set_ease(Tween.EASE_IN_OUT)
	_float_tween.set_trans(Tween.TRANS_SINE)
	_float_tween.tween_property($Body, "position", $Body.position + Vector2.DOWN * 100.0, 3.0)
	_float_tween.tween_property($Body, "position", $Body.position, 3.0)
	_float_tween.set_loops()


func _process(delta: float) -> void:
	if _boat:
		var y_distance := _boat.global_position.y - global_position.y
		if y_distance <= swim_speed * delta:
			global_position.y = _boat.global_position.y
		else:
			global_position.y += sign(y_distance) * swim_speed * delta


func _on_body_area_entered(area: Area2D) -> void:
	health = min(0.0, health - 5.0)
	%Health.update_health(health / max_health)
