class_name Canon
extends Node2D

@export var canon_aim_duration:float = 2 # seconds for the canon to move 2pi
@export var canon_input_deadzone:float = 0.1

@onready var aim_visual_node: Sprite2D = $CanonRotatingVisual

var aim_angle:float = 0
var aim_angle_target:float = 0
var is_rotating:bool = false

func _ready() -> void:
	aim_visual_node.rotation = aim_angle


func _process(_delta: float) -> void:
	var aim_vector: Vector2 = PlayerInput.get_targetting_vector()
	if aim_vector.length() > canon_input_deadzone:
		aim_angle_target = atan2(aim_vector.y, aim_vector.x)
		is_rotating = true
	else:
		is_rotating = false



func _physics_process(delta: float) -> void:
	if is_rotating:
		# TODO move over 0/2pi
		aim_angle = move_toward(aim_angle, aim_angle_target, 2 * PI / canon_aim_duration * delta)
		aim_visual_node.rotation = aim_angle
