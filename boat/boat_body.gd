class_name BoatBody
extends Area2D

signal crashed_on_ground()

var _terrain_collision_layer := 32

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(other: Area2D) -> void:
#	print("BoatBody collided with something: ", other.name, other.collision_layer)
	if other.collision_layer == _terrain_collision_layer:
		print("BoatBody collided with terrain")
		Music.play_sound(Music.Sounds.Hit_ground, global_position, self)
		crashed_on_ground.emit()
