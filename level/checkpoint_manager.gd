class_name CheckpointManager
extends Node2D

@onready var _level_node: Node2D = get_parent()
@onready var _checkpoints: Array = _level_node.get_tree().get_nodes_in_group("checkpoint")
@onready var _boat: Boat = _level_node.get_tree().get_first_node_in_group("boat")

var _current_checkpoint_index: int = 0

func _ready() -> void:
	_boat.crashed_on_ground.connect(_on_boat_crashed_on_ground)
	for index: int in _checkpoints.size():
		var checkpoint: Checkpoint = _checkpoints[index]
		checkpoint.index = index
		checkpoint.checkpoint_reached.connect(_on_checkpoint_reached)
	_checkpoints[0].is_reached = true

func _on_boat_crashed_on_ground() -> void:
	print("CheckpointManager: Boat crashed")
	_move_boat_to_checkpoint(_current_checkpoint_index)

func _move_boat_to_checkpoint(checkpoint_index: int) -> void:
	if checkpoint_index < 0 or checkpoint_index >= _checkpoints.size():
		print("Invalid checkpoint index: ", checkpoint_index)
		return
	var checkpoint: Checkpoint = _checkpoints[checkpoint_index]
	_boat.reset_for_re_spawn(checkpoint.get_respawn_position())

func _on_checkpoint_reached(index: int) -> void:
	print("CheckpointManager: Checkpoint reached: ", index)
	if index <= _current_checkpoint_index:
		print("CheckpointManager: Checkpoint already reached")
		return
	_current_checkpoint_index = index
