class_name AmmoCounter
extends Node2D

@export var distance: float = 50

@export var empty_sprite: PackedScene
@export var full_sprite: PackedScene

var _max_ammo: int = 5
var ammo_count: int = _max_ammo:
	set(value):
		ammo_count = min(_max_ammo, max(0, value))
		_update_ammo_visuals()

var full_ammo_sprites: Array = []

func initialize(max_ammo_count: int) -> void:
	_max_ammo = max_ammo_count
	for ammo_position:Vector2 in _get_ammo_positions():
		var empty_ammo_sprite: Sprite2D = empty_sprite.instantiate()
		empty_ammo_sprite.position = ammo_position
		add_child(empty_ammo_sprite)
		var full_ammo_sprite: Sprite2D = full_sprite.instantiate()
		full_ammo_sprite.position = ammo_position
		add_child(full_ammo_sprite)
		full_ammo_sprites.append(full_ammo_sprite)
	ammo_count = _max_ammo

func _update_ammo_visuals() -> void:
	for i in range(_max_ammo):
		if i < ammo_count:
			full_ammo_sprites[i].show()
		else:
			full_ammo_sprites[i].hide()

func _get_ammo_positions() -> Array:
	var positions: Array = []
	var total_distance := distance * _max_ammo
	for i in range(_max_ammo):
		var ammo_position := Vector2(distance * i - total_distance / 2, 0)
		positions.append(ammo_position)
	return positions
