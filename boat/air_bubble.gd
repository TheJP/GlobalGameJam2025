class_name AirBubble
extends Node2D

@export var upwards_speed: float = 100
@export var scale_increase_speed: float = 15
@export var target_scale: float = 10
@export var horizontal_speed_while_expanding: float = 270

var _float_upwards: bool = false
var _finished_expanding_callback: Callable
var _position_node: Node2D
var _horizontal_offset: float = 0

func set_position_node(node: Node2D) -> void:
	_position_node = node

func set_finished_expanding_callback(callback: Callable) -> void:
	_finished_expanding_callback = callback

func finish_expanding() -> void:
	_float_upwards = true
	if _finished_expanding_callback:
		_finished_expanding_callback.call()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _float_upwards:
		position.y -= upwards_speed * _delta
		if position.y < -10000:
			queue_free()
		return

	scale = Vector2(scale.x + scale_increase_speed * _delta, scale.y + scale_increase_speed * _delta)
	_horizontal_offset += horizontal_speed_while_expanding * _delta * _position_node.global_scale.x
	if _position_node:
		global_position = _position_node.global_position + Vector2(_horizontal_offset, 0)

	if target_scale > 0 && scale.x > target_scale:
		finish_expanding()
