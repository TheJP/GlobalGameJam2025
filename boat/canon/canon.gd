class_name Canon
extends Node2D

@export var canon_aim_distance:float = 100
@export var canon_aim_duration:float = 1 # seconds for the canon to move 2pi

@onready var aim_visual_node: Sprite2D = $CanonAimVisual

var aim_angle:float = 0
var aim_angle_target:float = 0

func _ready() -> void:
	aim_visual_node.position = Vector2(0, -canon_aim_distance)


func _process(_delta: float) -> void:
	var aim_vector: Vector2 = PlayerInput.get_targetting_vector()
	aim_angle_target = atan2(aim_vector.y, aim_vector.x)


func _physics_process(delta: float) -> void:
	aim_angle = move_toward(aim_angle, aim_angle_target, 2 * PI / canon_aim_duration * delta)
	aim_visual_node.rotation = aim_angle
