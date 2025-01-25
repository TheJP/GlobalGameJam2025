class_name Canon
extends Node2D

@export var canon_aim_duration: float = 7 # seconds for the canon to move 2pi
@export var canon_input_deadzone: float = 0.1
@export var canon_fire_rate: float = 2 # shots per second
@export var canon_bullet_capacity: int = 5
@export var canon_reload_time: float = 2 # seconds to reload # TODO: adjust to reload sound

@onready var aim_rotating_node: Node2D = $CanonRotatingNode
signal shoot(bullet: PackedScene, direction: Vector2, location: Vector2)
signal started_reloading
signal finished_reloading
# Aiming
var aim_angle: float        = 0
var aim_angle_target: float = 0
var is_rotating: bool       = false
# Shooting
var bullet: PackedScene  = preload("res://boat/canon/bullet.tscn")
var bullet_count: int    = canon_bullet_capacity
var shot_cooldown: float = 0
var reload_timer: float  = 0


func _ready() -> void:
	aim_angle = aim_rotating_node.rotation


func _process(_delta: float) -> void:
	if shot_cooldown > 0:
		shot_cooldown -= _delta
	if reload_timer > 0:
		reload_timer -= _delta
		if reload_timer <= 0:
			bullet_count = canon_bullet_capacity
			finished_reloading.emit()

	# Rotate the canon
	var aim_vector: Vector2 = PlayerInput.get_targetting_vector()
	if aim_vector.length() > canon_input_deadzone:
		aim_angle_target = atan2(aim_vector.y, aim_vector.x)
		is_rotating = true
	else:
		is_rotating = false

	# Shoot the canon
	if PlayerInput.is_just_pressed(PlayerInput.Action.FIRE):
		if bullet_count > 0 and shot_cooldown <= 0 and reload_timer <= 0:
			on_shoot()

	# Reload the canon
	if PlayerInput.is_just_pressed(PlayerInput.Action.RELOAD):
		if bullet_count < canon_bullet_capacity:
			reload_timer = canon_reload_time
			started_reloading.emit()


func on_shoot() -> void:
	bullet_count -= 1
	shot_cooldown = 1 / canon_fire_rate
	if shoot.get_connections().size() > 0:
		shoot.emit(bullet, Vector2(cos(aim_angle), sin(aim_angle)), global_position)


func _physics_process(delta: float) -> void:
	if is_rotating:
		# TODO move over 0/2pi
		aim_angle = move_toward(aim_angle, aim_angle_target, 2 * PI / canon_aim_duration * delta)
		aim_rotating_node.rotation = aim_angle
