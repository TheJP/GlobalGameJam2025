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


const _controller_to_device: Array[int] = [-1, -1, 0, 1, 2, 3, 4]

const _input_maps: Array[Dictionary] = [{
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
	}, {
		# [player_id, action]
		Action.FIRE: [1, "button_2"],
		Action.RELOAD: [0, "button_2"],
		Action.DESCEND: [0, "button_1"],
		Action.ASCEND_A: [0, "button_0"],
		Action.ASCEND_B: [1, "button_0"],
		Action.TARGET_LEFT: [0, "left"],
		Action.TARGET_RIGHT: [0, "right"],
		Action.TARGET_UP: [0, "up"],
		Action.TARGET_DOWN: [0, "down"],
		Action.FLY_LEFT: [1, "left"],
		Action.FLY_RIGHT: [1, "right"],
	}
]
var selected_input_map_index := 1
func get_input_map() -> Dictionary:
	return _input_maps[selected_input_map_index]

#const _input_map: Dictionary = {
	## [player_id, action]
	#Action.FIRE: [1, "button_2"],
	#Action.RELOAD: [0, "button_2"],
	#Action.DESCEND: [0, "button_1"],
	#Action.ASCEND_A: [0, "button_0"],
	#Action.ASCEND_B: [1, "button_0"],
	#Action.TARGET_LEFT: [1, "left"],
	#Action.TARGET_RIGHT: [1, "right"],
	#Action.TARGET_UP: [1, "up"],
	#Action.TARGET_DOWN: [1, "down"],
	#Action.FLY_LEFT: [0, "left"],
	#Action.FLY_RIGHT: [0, "right"],
#}


var player_to_controller: Array[int] = [0, 1]


func is_controller_just_pressed(controller: int, action: String) -> bool:
	#print("%s_%s" % [_controllers[controller], action])
	return Input.is_action_just_pressed("%s_%s" % [_controllers[controller], action])


func get_just_pressed_controllers(action: String) -> Array[int]:
	var result: Array[int] = []
	for controller in _controllers.size():
		if is_controller_just_pressed(controller, action):
			result.append(controller)
	return result


func is_controller_pressed(controller: int, action: String) -> bool:
	return Input.is_action_pressed("%s_%s" % [_controllers[controller], action])


func get_pressed_controllers(action: String) -> Array[int]:
	var result: Array[int] = []
	for controller in _controllers.size():
		if is_controller_pressed(controller, action):
			result.append(controller)
	return result


func add_player(controller: int) -> bool:
	if player_to_controller.size() >= 2:
		return false
	if player_to_controller.find(controller) >= 0:
		return false
	player_to_controller.append(controller)
	return true


func remove_player(controller: int) -> bool:
	var index := player_to_controller.find(controller)
	if index >= 0:
		player_to_controller.remove_at(index)
	return index >= 0


func clear_players() -> void:
	player_to_controller.clear()


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


func vibrate(action: Action, weak_magnitude: float, strong_magnitude: float, duration: float) -> void:
	assert(duration > 0.0)
	var mapping: Array = get_input_map()[action]
	var controller := player_to_controller[mapping[0]]
	var device := _controller_to_device[controller]
	if device >= 0:
		Input.start_joy_vibration(device, weak_magnitude, strong_magnitude, duration)


func vibrate_all(weak_magnitude: float, strong_magnitude: float, duration: float) -> void:
	var devices := {}
	for action: Action in Action.values():
		var mapping: Array = get_input_map()[action]
		var controller := player_to_controller[mapping[0]]
		var device := _controller_to_device[controller]
		if device >= 0:
			devices[device] = true
	for device: int in devices.values():
		Input.start_joy_vibration(device, weak_magnitude, strong_magnitude, duration)



func _get_action_name(action: Action) -> String:
	var mapping: Array = get_input_map()[action]
	var controller := player_to_controller[mapping[0]]
	return "%s_%s" % [_controllers[controller], mapping[1]]


# SPRITES

const _button_sprite_map: Dictionary = {
	Action.FIRE: "fire",
	Action.RELOAD: "reload",
	Action.DESCEND: "fly_down",
	Action.ASCEND_A: "pump1",
	Action.ASCEND_B: "pump2",
	Action.TARGET_LEFT: "move_target",
	Action.TARGET_RIGHT: "move_target",
	Action.TARGET_UP: "move_target",
	Action.TARGET_DOWN: "move_target",
	Action.FLY_LEFT: "fly_left_right",
	Action.FLY_RIGHT: "fly_left_right",
}
const sprite_base_path := "res://menu/sprites/ui_sprites/"
const sprite_suffix := ".png"

func get_sprite_for_player_icon(player_id: int) -> Texture2D:
	return load(sprite_base_path + "player" + str(player_id + 1) + sprite_suffix)

func get_sprite_for_action(action: Action) -> Texture2D:
	return load(sprite_base_path + _button_sprite_map[action] + sprite_suffix)

func get_all_actions_for_player(player_id: int) -> Array[Action]:
	var players_actions: Array[Action] = []
	var input_map := get_input_map()
	for action: Action in input_map:
		var value:Array = input_map[action]
		var action_player_id:int = value[0]
		if (player_id == action_player_id):
			players_actions.append(action)
	return players_actions

func get_all_distinct_sprites_for_player(player_id: int) -> Array[Texture2D]:
	var players_actions: Array[Action] = get_all_actions_for_player(player_id)
	var sprite_paths: Array[Texture2D] = []
	for action in players_actions:
		var sprite_path := get_sprite_for_action(action)
		if not sprite_paths.has(sprite_path):
			sprite_paths.append(sprite_path)
	return sprite_paths
