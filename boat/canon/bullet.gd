class_name Bullet
extends Node2D

@export var default_speed: float = 1000
@export var lifetime: float = 2

var velocity: Vector2 = Vector2()
var lifetime_timer: float = 0

func initialize(shoot_direction: Vector2, spawn_position: Vector2, speed: float = default_speed) -> void:
	position = spawn_position
	velocity = shoot_direction.normalized() * speed
	rotation = velocity.angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position += velocity * _delta
	lifetime_timer += _delta
	if lifetime_timer >= lifetime:
		queue_free()
