class_name Boat
extends Node2D

@export var level_node: Level = get_parent()

var value_scale: float = 5

@export var initial_height: float = 100
@export var max_height: float = 1080-550
@export var min_height: float = -(2160-250)
@export var min_scale: float = 0.5
@export var max_scale: float = 1.5
@export var speed_up: float = 30 * value_scale
@export var speed_down: float = 60 * value_scale
@export var speed_right: float = 60 * value_scale
@export var speed_left: float = 25 * value_scale
@export var pump_height_add: float = 10 * value_scale
@export var speed_air_release: float = 65 * value_scale # the higher speed_air_release is compared to speed_down, the longer the boat will sink after stopping to release air.
@export var size_change_speed: float = 0.5

signal crashed_on_ground()

@onready var body_node: BoatBody = $Bobbing/Body
@onready var boat_bubble_node: BoatBubble = $Bobbing/Bubble
@onready var pump_node: Pump = $Bobbing/Pump
@onready var canon_node: Canon = $Bobbing/Canon
@onready var horizontal_movement_visualization: HorizontalMovementVisualization = $Bobbing/HorizontalMovementVisualization

@onready var air_bubble: PackedScene = preload("res://boat/air_bubble.tscn")

func get_hit(hit_position: Vector2, hit_severity: float) -> void:
	if _target_height <= min_height:
		return
	hit_position = hit_position.move_toward(boat_bubble_node.global_position, 20)
	var new_position_node: Node2D = Node2D.new()
	boat_bubble_node.add_child(new_position_node)
	print("parent: ", new_position_node.get_parent().name)
	new_position_node.global_position = hit_position
	var target_scale: float = hit_severity * 5
	var airbubble := _create_air_bubble(new_position_node, target_scale, true)
	airbubble.horizontal_speed_while_expanding = 0
	airbubble.vertical_speed_while_expanding = 0
	airbubble.scale_increase_speed /= 2
	var height_loss: float = hit_severity
	Music.play_sound(Music.Sounds.Being_shot_losing_air, global_position, self)
	_lose_air(height_loss)

func _lose_air(air_loss: float) -> void:
	if _target_height <= min_height:
		return
	_target_height -= air_loss * speed_air_release
	if _target_height < min_height:
		# arrived at the bottom
		_target_height = min_height
#		if _current_air_bubble != null:
#			_current_air_bubble.finish_expanding()
	_update_scale()

var _current_air_bubble: AirBubble = null
func _create_air_bubble(air_bubble_position_node: Node2D, target_scale: float = -1, destroy_air_bubble_position_node: bool = false) -> AirBubble:
	if _target_height <= min_height:
		return
	var air_bubble_instance : AirBubble = air_bubble.instantiate()
	call_deferred("add_child", air_bubble_instance)
#	add_child(air_bubble_instance)
	air_bubble_instance.target_scale = target_scale
	air_bubble_instance.global_position = air_bubble_position_node.global_position # optional
	air_bubble_instance.set_position_node(air_bubble_position_node)
	air_bubble_instance.set_finished_expanding_callback(func () -> void:
		air_bubble_instance.reparent(level_node)
		print("Air bubble finished expanding")
		if destroy_air_bubble_position_node and air_bubble_position_node != null:
			air_bubble_position_node.queue_free()
	)
	return air_bubble_instance


#	var air_bubble_tween: Tween = get_tree().create_tween()
#	air_bubble_tween.tween_property(air_bubble_instance, "scale", Vector2(4,4), 1)
#	air_bubble_tween.tween_callback(air_bubble_instance.on_finished_expanding)
#	air_bubble_tween.tween_callback(func () -> void: level_node.add_child(air_bubble_instance))
#	air_bubble_tween.play()


func pump_up(amount: float = pump_height_add) -> void:
	if _target_height >= max_height:
		return
	_target_height += amount
	if _target_height > max_height:
		_target_height = max_height
	_update_scale()


func reset_for_re_spawn(respawn_position: Vector2) -> void:
	if _current_air_bubble != null:
		_current_air_bubble.finish_expanding()
	if _current_air_release_sound != null:
		_current_air_release_sound.stop()
		_current_air_release_sound.queue_free()
		_current_air_release_sound = null
	global_position = respawn_position
	_target_height = -global_position.y
	_update_scale()
	$Bobbing.reset()
	_respawn_pause_timer = respawn_pause_time

@export var respawn_pause_time: float = 0.6
@export var initial_spawn_pause_time: float = 0.0
var _respawn_pause_timer: float = initial_spawn_pause_time

var _balloon_scale_tween: Tween
var _target_height: float


func _ready() -> void:
	_target_height = initial_height
	_update_scale()
	pump_node.pump_up.connect(_on_Pump_pump_up)
	boat_bubble_node.hit.connect(func(hit_position: Vector2, hit_severity: float) -> void: get_hit(hit_position, hit_severity))
	body_node.crashed_on_ground.connect(func() -> void:
		crashed_on_ground.emit()
	)


var _current_air_release_sound: AudioStreamPlayer2D = null

func _process(delta: float) -> void:
	var _respawn_timer_reached_zero: bool = false
	if _respawn_pause_timer > 0:
		_respawn_pause_timer -= delta
		if _respawn_pause_timer <= 0:
			_respawn_pause_timer = 0
			_respawn_timer_reached_zero = true
		else:
			return
	if PlayerInput.is_just_pressed(PlayerInput.Action.DESCEND) or (_respawn_timer_reached_zero and PlayerInput.is_pressed(PlayerInput.Action.DESCEND)):
		var spawn_position_node := boat_bubble_node.get_air_bubble_spawn_position_node()
		_current_air_bubble = _create_air_bubble(spawn_position_node)
		_current_air_release_sound = Music.play_sound(Music.Sounds.Air_release, global_position, self)
	if PlayerInput.is_pressed(PlayerInput.Action.DESCEND):
		_lose_air(delta)
	if PlayerInput.is_just_released(PlayerInput.Action.DESCEND):
		if _current_air_bubble != null:
			_current_air_bubble.finish_expanding()
		if _current_air_release_sound != null:
			_current_air_release_sound.stop()
			_current_air_release_sound.queue_free()
			_current_air_release_sound = null



func _physics_process(delta: float) -> void:
	var speed: float = speed_up if _target_height > -position.y else speed_down
	position = position.move_toward(Vector2(position.x, -_target_height), speed * delta)
	_handle_horizontal_movement(delta)


func _on_Pump_pump_up() -> void:
	pump_up()


func _update_scale() -> void:
	if _balloon_scale_tween != null:
		_balloon_scale_tween.kill()
		#		balloon_scale_tween.pause()
		#		balloon_scale_tween.free()
		_balloon_scale_tween = null

	var target_scale: float = _get_target_bubble_size()
	var duration: float     = abs(target_scale - boat_bubble_node.scale.x) * (1 / size_change_speed)
	_balloon_scale_tween = get_tree().create_tween()
	_balloon_scale_tween.tween_property(boat_bubble_node, "scale", Vector2(target_scale, target_scale), duration)
	_balloon_scale_tween.play()


func _get_target_bubble_size() -> float:
	return (_target_height - min_height) / (max_height - min_height) * (max_scale - min_scale) + min_scale


func _handle_horizontal_movement(delta: float) -> void:
	if _respawn_pause_timer > 0:
		return
	var horizontal_movement: float = PlayerInput.get_horizontal_movement()
	var horizontal_speed: float = speed_right if horizontal_movement > 0 else speed_left
	position.x += horizontal_movement * horizontal_speed * delta
	var max_x := level_node.max_x
	var min_x := level_node.min_x
	if position.x > max_x:
		position.x = max_x
	if position.x < min_x:
		position.x = min_x
	horizontal_movement_visualization.set_horizontal_movement(horizontal_movement)
