extends Node


enum Action {
	FIRE,
	RELOAD,
	DESCEND,
	ASCEND_A,
	ASCEND_B,
	TARGET_LEFT,
	TARGET_RIGHT,
	TARGET_UP,
	TARGET_DOWN,
	FLY_LEFT,
	FLY_RIGHT,
}


const _controllers: Array[String] = [
	"player_0",
	"player_1",
	"player_2",
	"player_3",
	"player_4",
	"player_5",
	"player_6",
]


const _input_map: Dictionary = {
	# [player_id, action]
	Action.FIRE: [1, "button_2"],
	Action.RELOAD: [0, "button_2"],
	Action.DESCEND: [0, "button_1"],
	Action.ASCEND_A: [0, "button_0"],
	Action.ASCEND_B: [1, "button_0"],
	Action.TARGET_LEFT: [1, "left"],
	Action.TARGET_RIGHT: [1, "right"],
	Action.TARGET_UP: [1, "up"],
	Action.TARGET_DOWN: [1, "down"],
	Action.FLY_LEFT: [0, "left"],
	Action.FLY_RIGHT: [0, "right"],
}


const _player_to_controller: Array[int] = []


func is_controller_just_pressed(controller: int, action: String):
	Input.is_action_just_pressed("%s_%s" % [_controllers[controller], action])


func get_just_pressed_controllers(action: String) -> Array[int]:
	var result: Array[int] = []
	for i in range(len(_controllers)):
		if is_controller_just_pressed(i, action):
			result.append(i)
	return result


func add_player(controller: int) -> bool:
	if len(_player_to_controller) >= 2:
		return false
	_player_to_controller.append(controller)
	return true


func is_pressed(action: Action) -> bool:
	return Input.is_action_pressed(_get_action_name(action))


func is_just_pressed(action: Action) -> bool:
	return Input.is_action_just_pressed(_get_action_name(action))


func is_just_released(action: Action) -> bool:
	return Input.is_action_just_released(_get_action_name(action))


func get_targetting_vector() -> Vector2:
	return Input.get_vector(
		_get_action_name(Action.TARGET_LEFT),
		_get_action_name(Action.TARGET_RIGHT),
		_get_action_name(Action.TARGET_UP),
		_get_action_name(Action.TARGET_DOWN))


func get_horizontal_movement() -> float:
	return Input.get_axis(_get_action_name(Action.FLY_LEFT), _get_action_name(Action.FLY_RIGHT))


func _get_action_name(action: Action) -> String:
	var mapping = _input_map[action]
	var controller = _player_to_controller[mapping[0]]
	return "%s_%s" % [_controllers[controller], mapping[1]]
