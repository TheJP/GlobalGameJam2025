class_name Checkpoint
extends Sprite2D

@export var reached_sprite: Texture

signal checkpoint_reached(index: int)

@onready var _level_node: Node2D = get_parent()
@onready var _boat: Boat = _level_node.get_tree().get_first_node_in_group("boat")
@onready var respawn_position: Node2D = $RespawnPosition

var index: int       = -1
var is_reached: bool = false

func get_respawn_position() -> Vector2:
	return respawn_position.global_position

func _process(_delta: float) -> void:
	if is_reached:
		return
	if _boat.global_position.x >= global_position.x:
		is_reached = true
		checkpoint_reached.emit(index)
		texture = reached_sprite
		print("checkpoint ", index, " reached!")
