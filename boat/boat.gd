class_name Boat
extends Node2D

@export var initial_height: float = 100
@export var max_height: float = 200
@export var min_height: float = -200
@export var min_scale: float = 0.5
@export var max_scale: float = 1.5
@export var speed_up: float = 80
@export var speed_down: float = 100
@export var pump_height_add: float = 8
@export var lose_air_sub: float = 20
@export var size_change_speed: float = 0.5

@onready var body_node: BoatBody = $Body
@onready var bubble_node: BoatBubble = $Bubble
@onready var pump_node: Pump = $Pump
@onready var canon_node: Canon = $Canon
signal shoot(bullet: PackedScene, direction: Vector2, location: Vector2)


func lose_air(amount: float = lose_air_sub) -> void:
	if target_height <= min_height:
		return
	target_height -= amount
	if target_height < min_height:
		target_height = min_height
	_update_scale()


func pump_up(amount: float = pump_height_add) -> void:
	if target_height >= max_height:
		return
	target_height += amount
	if target_height > max_height:
		target_height = max_height
	_update_scale()

var balloon_scale_tween: Tween
var target_height: float = 0


func _ready() -> void:
	target_height = initial_height
	_update_scale()
	pump_node.pump_up.connect(_on_Pump_pump_up)
	# Extend the signal outwards
	canon_node.shoot.connect(func(bullet: PackedScene, direction: Vector2, location: Vector2) -> void: shoot.emit(bullet, direction, location))


func _process(_delta: float) -> void:
	if PlayerInput.is_just_pressed(PlayerInput.Action.DESCEND):
		lose_air()


func _physics_process(delta: float) -> void:
	var speed: float = speed_up if target_height > -position.y else speed_down
	position = position.move_toward(Vector2(position.x, -target_height), speed * delta)


func _on_Pump_pump_up() -> void:
	pump_up()


func _update_scale() -> void:
	if balloon_scale_tween != null:
		balloon_scale_tween.kill()
		#		balloon_scale_tween.pause()
		#		balloon_scale_tween.free()
		balloon_scale_tween = null

	var target_scale: float = _get_target_bubble_size()
	var duration: float     = abs(target_scale - bubble_node.scale.x) * (1 / size_change_speed)
	balloon_scale_tween = get_tree().create_tween()
	balloon_scale_tween.tween_property(bubble_node, "scale", Vector2(target_scale, target_scale), duration)
	balloon_scale_tween.play()


func _get_target_bubble_size() -> float:
	return (target_height - min_height) / (max_height - min_height) * (max_scale - min_scale) + min_scale
