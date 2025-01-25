class_name Bullet
extends Area2D

@export var default_speed: float = 500
@export var lifetime: float = 5
@export var continue_after_hit: bool = false
@export var rotation_speed: float = 1.3

@onready var bullet_visual: Sprite2D = $BulletVisual

var velocity: Vector2 = Vector2()
var lifetime_timer: float = 0

func initialize(shoot_direction: Vector2, spawn_position: Vector2, speed: float = default_speed) -> void:
	position = spawn_position
	velocity = shoot_direction.normalized() * speed
	rotation = velocity.angle()

func _ready() -> void:
	area_entered.connect(on_area_entered)

func _process(_delta: float) -> void:
	position += velocity * _delta
	lifetime_timer += _delta
	bullet_visual.rotate(2 * PI * rotation_speed * _delta)
	if lifetime_timer >= lifetime:
		queue_free()

func on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.queue_free()
		if not continue_after_hit:
			queue_free()
