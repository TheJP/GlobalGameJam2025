class_name Pump
extends Node2D

signal pump_up

@export var pump_duration:float = 0.15 # seconds for the pump to move from one end to the other
@export var pump_max_rotation:float = 2 * PI / 10

@onready var pump_bar_sprite: Sprite2D = $PumpBarSprite

var pump_position:float = 0
var pump_goal:float = 0
var previous_pump_goal:float = 0

func _process(delta: float) -> void:
	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_A):
		pump_goal = -1
	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_B):
		pump_goal = 1

	if pump_position == pump_goal:
		# we are already at the goal
		return

	pump_position = move_toward(pump_position, pump_goal, 2.0 / pump_duration * delta) # 2.0 because the pump moves from -1 to +1, i.e. a total of 2
	pump_bar_sprite.rotation = pump_position * pump_max_rotation

	if pump_position == pump_goal and pump_goal != previous_pump_goal:
		Music.play_sound(Music.Sounds.Pump, global_position, self)
		if pump_goal < 0:
			PlayerInput.vibrate(PlayerInput.Action.ASCEND_A, 0.4, 0.0, 0.1)
		else:
			PlayerInput.vibrate(PlayerInput.Action.ASCEND_B, 0.4, 0.0, 0.1)
		pump_up.emit()
		previous_pump_goal = pump_goal
