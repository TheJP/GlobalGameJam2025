class_name Canon
extends Node2D

@export var aim_speed: float = 4
@export var input_deadzone: float = 0.1
@export var fire_rate: float = 3 # shots per second
@export var bullet_capacity: int = 10
@export var reload_time: float = 0.7 # seconds to reload
# Signals
signal started_reloading
signal finished_reloading
# Child Nodes
@onready var _aim_rotating_node: Node2D = $CanonRotatingNode
@onready var _ammo_counter: AmmoCounter = $AmmoCounter
@onready var _canon_shooting: CanonShooting = $CanonRotatingNode/CanonShooting

# Aiming
var _aim_angle: float        = 0
var _aim_angle_target: float = 0
var _is_rotating: bool       = false
# Shooting
var _current_bullet_count: int    = bullet_capacity
var _current_shot_cooldown: float = 0
var _current_reload_timer: float  = 0


func _ready() -> void:
	_aim_angle = _aim_rotating_node.rotation
	_ammo_counter.initialize(bullet_capacity)


func _process(_delta: float) -> void:
	if _current_shot_cooldown > 0:
		_current_shot_cooldown -= _delta
	if _current_reload_timer > 0:
		_current_reload_timer -= _delta
		if _current_reload_timer <= 0:
			_current_bullet_count = bullet_capacity
			_ammo_counter.ammo_count = _current_bullet_count
			finished_reloading.emit()

	# Rotate the canon
	var aim_vector: Vector2 = PlayerInput.get_targetting_vector()
	if aim_vector.length() > input_deadzone:
		_aim_angle_target = atan2(aim_vector.y, aim_vector.x)
		_is_rotating = true
	else:
		_is_rotating = false

	# Shoot the canon
	if PlayerInput.is_just_pressed(PlayerInput.Action.FIRE):
		if _current_bullet_count > 0 and _current_shot_cooldown <= 0 and _current_reload_timer <= 0:
			_on_shoot()

	# Reload the canon
	if PlayerInput.is_just_pressed(PlayerInput.Action.RELOAD):
		if _current_bullet_count < bullet_capacity and _current_reload_timer <= 0:
			_current_reload_timer = reload_time
			_ammo_counter.ammo_count = 0
			Music.play_sound(Music.Sounds.Reload, global_position, self)
			started_reloading.emit()
			var bullet_reload_tween := get_tree().create_tween()
			bullet_reload_tween.tween_property(_ammo_counter, "ammo_count", bullet_capacity, reload_time)
			bullet_reload_tween.play()


func _on_shoot() -> void:
	_current_bullet_count -= 1
	_current_shot_cooldown = 1 / fire_rate
	_ammo_counter.ammo_count = _current_bullet_count
	Music.play_sound(Music.Sounds.Shoot, global_position, self)
	var direction: Vector2 = Vector2(cos(_aim_angle), sin(_aim_angle))
	_canon_shooting.shoot_bullet(direction)


func _physics_process(delta: float) -> void:
	if _is_rotating:
		var difference := angle_difference(_aim_angle, _aim_angle_target)
		if abs(difference) <= aim_speed * delta:
			_aim_angle = _aim_angle_target
		else:
			_aim_angle += sign(difference) * aim_speed * delta
		_aim_rotating_node.rotation = _aim_angle
