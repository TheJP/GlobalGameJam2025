class_name BulletSpawner
extends Node

@export var boat: Boat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boat.shoot.connect(_on_Boat_shoot)

func _on_Boat_shoot(bullet: PackedScene, direction: Vector2, location: Vector2) -> void:
	var bullet_instance: Bullet = bullet.instantiate()
	add_child(bullet_instance)
	bullet_instance.initialize(direction, location)
	bullet_instance.position = location
	add_child(bullet_instance)
