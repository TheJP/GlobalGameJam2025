class_name BoatBody
extends Area2D

signal crashed_on_ground()
signal bounced_against_enemy(other: CollisionObject2D)

var _terrain_collision_layer := 6
var _enemy_collision_layer := 4

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func handle_collision(collision: KinematicCollision2D) -> void:
	var collider_node: CollisionObject2D = collision.get_collider()
	var hit_position := collision.get_position()
	if collider_node.get_collision_layer_value(_terrain_collision_layer):
		print("BoatBody collided with terrain")
		Music.play_sound(Music.Sounds.Hit_ground, global_position, self)
		crashed_on_ground.emit()
	if collider_node.get_collision_layer_value(_enemy_collision_layer):
		bounced_against_enemy.emit(collider_node)

func _on_area_entered(other: Area2D) -> void:
	pass
#	print("BoatBody collided with something: ", other.name, other.collision_layer)
	#if other.get_collision_layer_value(_terrain_collision_layer):
		#print("BoatBody collided with terrain")
		#Music.play_sound(Music.Sounds.Hit_ground, global_position, self)
		#crashed_on_ground.emit()
	#if other.get_collision_layer_value(_enemy_collision_layer):
		#bounced_against_enemy.emit(other)
