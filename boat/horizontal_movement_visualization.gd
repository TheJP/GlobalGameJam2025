class_name HorizontalMovementVisualization
extends Node2D

@onready var bubble_particles: CPUParticles2D = $HorizontalBubbles

var _previous_movement: Movement = Movement.NO_MOVEMENT

func _ready() -> void:
	bubble_particles.emitting = false

func set_horizontal_movement(horizontal_movement: float) -> void:
	var movement: Movement = _get_movement(horizontal_movement)
	if movement == _previous_movement:
		return
	if movement == Movement.NO_MOVEMENT:
		bubble_particles.emitting = false
	else:
		bubble_particles.emitting = true
		bubble_particles.direction.x = 1 if movement == Movement.LEFT else -1 # Bubble go against the movement
		if movement == Movement.LEFT:
			bubble_particles.speed_scale = 1
		else:
			bubble_particles.speed_scale = 2
	_previous_movement = movement


func _get_movement(horizontal_movement: float) -> Movement:
	if horizontal_movement < 0:
		return Movement.LEFT
	if horizontal_movement > 0:
		return Movement.RIGHT
	return Movement.NO_MOVEMENT



enum Movement {
	LEFT,
	RIGHT,
	NO_MOVEMENT
}
