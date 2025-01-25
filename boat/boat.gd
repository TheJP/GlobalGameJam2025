class_name Boat
extends CharacterBody2D

@export var initial_height:float = 100
@export var max_height:float = 200
@export var min_height:float = -200

@export var speed_up:float = 30
@export var speed_down:float = 50
@export var pump_height_add:float = 3
@export var lose_air_sub:float = 10

@onready var body_node: BoatBody = $Body

func lose_air(amount:float = lose_air_sub):
	target_height -= amount
	if target_height < min_height:
		target_height = min_height

func pump_up(amount:float = pump_height_add):
	target_height += amount
	if target_height > max_height:
		target_height = max_height


var target_height:float = 0

func _ready():
	target_height = initial_height

func _process(_delta):
	if PlayerInput.is_just_pressed(PlayerInput.Action.DESCEND):
		lose_air()

	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_A):
		pump_up()
	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_B):
		pump_up()


# 	if Input.is_action_just_pressed("ui_up"):
# 		pump_up()
# 	if Input.is_action_just_pressed("ui_down"):
# 		lose_air()

func _physics_process(delta):
	var speed:float = speed_up if target_height > -position.y else speed_down
	position = position.move_toward(Vector2(position.x, -target_height), speed * delta)
