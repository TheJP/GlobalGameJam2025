class_name Pump
extends Node2D

signal pump_up

func _process(delta):
	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_A):
		pump_up.emit()
	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_B):
		pump_up.emit()
