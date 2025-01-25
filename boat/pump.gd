class_name Pump
extends Node2D

signal pump_up

@export var pump_duration:float = 0.1 # seconds for the pump to move from one end to the other

var pump_position:float = 0
var pump_goal:float = 0

func _process(delta):
	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_A):
		pump_goal = 1
	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_B):
		pump_goal = -1

	if pump_position == pump_goal:
		# we are already at the goal
		return

	pump_position = move_toward(pump_position, pump_goal, 1 / pump_duration * delta)

	if pump_position == pump_goal and pump_goal != 0:
		pump_up.emit()
