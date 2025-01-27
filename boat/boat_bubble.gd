class_name BoatBubble
extends Area2D

signal hit(hit_position: Vector2, hit_severity: float)
@onready var air_bubble_spawn_position: Node2D = $AirBubbleSpawnPosition


func get_air_bubble_spawn_position_node() -> Node2D:
	return air_bubble_spawn_position


func get_bubble_centre() -> Vector2:
	return $BubbleVisualization.global_position


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(other: Area2D) -> void:
	if other.is_in_group("enemy"):
		var hit_position: Vector2 = other.global_position
		var hit_severity: float   = 1 # TODO get from enemy
		hit.emit(hit_position, hit_severity)
		print("BoatBubble hit by enemy")
	if other.is_in_group("terrain"):
		var hit_position: Vector2 = other.global_position
		var hit_severity: float   = 1
		hit.emit(hit_position, hit_severity)
		print("BoatBubble hit wall")
		# TODO: Check again after some time, if still in area, and if so, hit again.
		#       Currently only first time hit is registered, which is ok if hit from below, but when hit from side, it might stay in there.
