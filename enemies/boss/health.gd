extends NinePatchRect


var _rect_max_width: float


func _ready() -> void:
	_rect_max_width = size.x


func update_health(fraction: float) -> void:
	fraction = clamp(fraction, 0.0, 1.0)
	size.x = fraction * _rect_max_width
	#position.x = (1.0 - fraction) * _rect_max_width * scale.x * -0.5
