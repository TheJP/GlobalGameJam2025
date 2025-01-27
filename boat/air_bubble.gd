class_name AirBubble
extends Area2D

@export var upwards_speed: float = 150
@export var scale_increase_speed: float = 15
@export var target_scale: float = 10
@export var horizontal_speed_while_expanding: float = 270
@export var vertical_speed_while_expanding: float = 0

var _float_upwards: bool = false
var _finished_expanding_callback: Callable
var _position_node: Node2D
var _horizontal_offset: float = 0
var _vertical_offset: float = 0

func _ready() -> void:
	pass


func set_position_node(node: Node2D) -> void:
	_position_node = node

func set_finished_expanding_callback(callback: Callable) -> void:
	_finished_expanding_callback = callback

func finish_expanding() -> void:
	_float_upwards = true
	area_entered.connect(_on_area_entered)
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
	_vertical_offset += vertical_speed_while_expanding * _delta * _position_node.global_scale.y
	if _position_node != null:
		global_position = _position_node.global_position + Vector2(_horizontal_offset, _vertical_offset)
	else:
		print("No position node set for air bubble")

	if target_scale > 0 && scale.x > target_scale:
		print("Finished expanding to target scale: ", target_scale)
		finish_expanding()


func _on_area_entered(area: Area2D) -> void:
#	if area.is_in_group("enemy") or area.is_in_group("terrain"): # don't use groups, just use collision masks to define what can pop the bubble
	_pop()


func _pop() -> void:
	print("AirBubble popped (by enemy or terrain)")
	# TODO animate popping
	# TODO play sound
	queue_free()
