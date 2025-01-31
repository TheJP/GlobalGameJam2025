class_name CanonShooting
extends Node2D

@export var _bullet_scene: PackedScene
@export var _bullet_shooting_speed: float = 500

var _level_node: Level          = null
var _previous_position: Vector2 = Vector2.ZERO
var _current_velocity: Vector2  = Vector2.ZERO


func _ready() -> void:
	var current_scene_node := get_tree().get_current_scene()
	if current_scene_node is Level:
		_level_node = current_scene_node
	_previous_position = global_position


func _physics_process(delta: float) -> void:
	var current_position: Vector2 = global_position
	_current_velocity = (current_position - _previous_position) / delta
	_previous_position = current_position


func shoot_bullet(direction: Vector2) -> void:
	var bullet_instance: Bullet    = _bullet_scene.instantiate()
	var location: Vector2          = global_position
	var adjusted_velocity: Vector2 = direction.normalized() * _bullet_shooting_speed + _current_velocity
	bullet_instance.initialize(adjusted_velocity, location)
	bullet_instance.position = location
	if _level_node != null:
		_level_node.add_child(bullet_instance)
	else:
		add_child(bullet_instance)
