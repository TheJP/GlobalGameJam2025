extends Node2D

var _float_tween: Tween

func _process(_delta: float) -> void:
	if _float_tween != null:
		return
	if PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_A)\
			or PlayerInput.is_just_pressed(PlayerInput.Action.ASCEND_B)\
			or PlayerInput.is_just_pressed(PlayerInput.Action.TARGET_UP)\
			or PlayerInput.is_just_pressed(PlayerInput.Action.FLY_RIGHT)\
			or PlayerInput.is_just_pressed(PlayerInput.Action.FLY_LEFT):
		start_bobbing()

func start_bobbing() -> void:
	_float_tween = create_tween()
	_float_tween.set_ease(Tween.EASE_IN_OUT)
	_float_tween.set_trans(Tween.TRANS_SINE)
	_float_tween.tween_property(self, "position", self.position + Vector2.DOWN * 100.0, 2)
	_float_tween.tween_property(self, "position", self.position, 2)
	_float_tween.set_loops()
