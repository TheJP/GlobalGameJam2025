class_name BoatBubble
extends Area2D

@onready var air_bubble_spawn_position: Node2D = $AirBubbleSpawnPosition

func get_air_bubble_spawn_position_node() -> Node2D:
	return air_bubble_spawn_position
