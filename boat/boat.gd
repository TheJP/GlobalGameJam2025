class_name Boat
extends Node2D

@export var initial_height:float = 100
@export var max_height:float = 200
@export var min_height:float = -200

@export var speed_up:float = 60
@export var speed_down:float = 100
@export var pump_height_add:float = 8
@export var lose_air_sub:float = 20

@onready var body_node: BoatBody = $Body
@onready var bubble_node: BoatBubble = $Bubble

@onready var pump_node: Pump = $Pump

func lose_air(amount:float = lose_air_sub) -> void:
	target_height -= amount
	if target_height < min_height:
		target_height = min_height

func pump_up(amount:float = pump_height_add) -> void:
	target_height += amount
	if target_height > max_height:
		target_height = max_height

var target_height:float = 0

func _ready() -> void:
	target_height = initial_height
	pump_node.pump_up.connect(_on_Pump_pump_up)

func _process(_delta: float) -> void:
	if PlayerInput.is_just_pressed(PlayerInput.Action.DESCEND):
		lose_air()

func _physics_process(delta: float) -> void:
	var speed:float = speed_up if target_height > -position.y else speed_down
	position = position.move_toward(Vector2(position.x, -target_height), speed * delta)

func _on_Pump_pump_up() -> void:
	pump_up()
