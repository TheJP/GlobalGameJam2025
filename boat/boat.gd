class_name Boat
extends Node2D

@export var level_node: Node2D

@export var initial_height: float = 100
@export var max_height: float = 200
@export var min_height: float = -200
@export var min_scale: float = 0.5
@export var max_scale: float = 1.5
@export var speed_up: float = 80
@export var speed_down: float = 100
@export var pump_height_add: float = 8
#@export var lose_air_sub: float = 20
@export var size_change_speed: float = 0.5

signal shoot(bullet: PackedScene, direction: Vector2, location: Vector2)

@onready var body_node: BoatBody = $Body
@onready var bubble_node: BoatBubble = $Bubble
@onready var pump_node: Pump = $Pump
@onready var canon_node: Canon = $Canon

@onready var air_bubble: PackedScene = preload("res://boat/air_bubble.tscn")

func get_hit(hit_position: Vector2, hit_severity: float) -> void:
	var new_position_node: Node2D = Node2D.new()
	add_child(new_position_node)
	new_position_node.global_position = hit_position
	var target_scale: float = hit_severity * 2
	_create_air_bubble(new_position_node, target_scale, true)
	var height_loss: float = hit_severity * 100
	_lose_air(height_loss)

func _lose_air(delta: float) -> void:
	if _target_height <= min_height:
		return
	_target_height -= delta * speed_down
	if _target_height < min_height:
		# arrived at the bottom
		_target_height = min_height
		if _current_air_bubble != null:
			_current_air_bubble.finish_expanding()
	_update_scale()

var _current_air_bubble: AirBubble = null
func _create_air_bubble(air_bubble_position_node: Node2D, target_scale: float = -1, destroy_air_bubble_position_node: bool = false) -> void:
	if _target_height <= min_height:
		return
	var air_bubble_instance : AirBubble = air_bubble.instantiate()
	add_child(air_bubble_instance)
	air_bubble_instance.target_scale = target_scale
	air_bubble_instance.global_position = air_bubble_position_node.global_position # optional
	air_bubble_instance.set_finished_expanding_callback(func () -> void:
		air_bubble_instance.reparent(level_node)
		print("Air bubble finished expanding")
		if destroy_air_bubble_position_node:
			air_bubble_position_node.queue_free()
	)
	air_bubble_instance.set_position_node(air_bubble_position_node)
	_current_air_bubble = air_bubble_instance

#	var air_bubble_tween: Tween = get_tree().create_tween()
#	air_bubble_tween.tween_property(air_bubble_instance, "scale", Vector2(4,4), 1)
#	air_bubble_tween.tween_callback(air_bubble_instance.on_finished_expanding)
#	air_bubble_tween.tween_callback(func () -> void: level_node.add_child(air_bubble_instance))
#	air_bubble_tween.play()


func pump_up(amount: float = pump_height_add) -> void:
	if _target_height >= max_height:
		return
	_target_height += amount
	if _target_height > max_height:
		_target_height = max_height
	_update_scale()

var _balloon_scale_tween: Tween
var _target_height: float = 0


func _ready() -> void:
	_target_height = initial_height
	_update_scale()
	pump_node.pump_up.connect(_on_Pump_pump_up)
	# Extend the signal outwards
	canon_node.shoot.connect(func(bullet: PackedScene, direction: Vector2, location: Vector2) -> void: shoot.emit(bullet, direction, location))


func _process(delta: float) -> void:
	if PlayerInput.is_just_pressed(PlayerInput.Action.DESCEND):
		var spawn_position_node := bubble_node.get_air_bubble_spawn_position_node()
		_create_air_bubble(spawn_position_node)
	if PlayerInput.is_pressed(PlayerInput.Action.DESCEND):
		_lose_air(delta)
	if PlayerInput.is_just_released(PlayerInput.Action.DESCEND):
		if _current_air_bubble != null:
			_current_air_bubble.finish_expanding()



func _physics_process(delta: float) -> void:
	var speed: float = speed_up if _target_height > -position.y else speed_down
	position = position.move_toward(Vector2(position.x, -_target_height), speed * delta)


func _on_Pump_pump_up() -> void:
	pump_up()


func _update_scale() -> void:
	if _balloon_scale_tween != null:
		_balloon_scale_tween.kill()
		#		balloon_scale_tween.pause()
		#		balloon_scale_tween.free()
		_balloon_scale_tween = null

	var target_scale: float = _get_target_bubble_size()
	var duration: float     = abs(target_scale - bubble_node.scale.x) * (1 / size_change_speed)
	_balloon_scale_tween = get_tree().create_tween()
	_balloon_scale_tween.tween_property(bubble_node, "scale", Vector2(target_scale, target_scale), duration)
	_balloon_scale_tween.play()


func _get_target_bubble_size() -> float:
	return (_target_height - min_height) / (max_height - min_height) * (max_scale - min_scale) + min_scale
