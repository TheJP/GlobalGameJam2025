extends VBoxContainer

@export var player_id: int = -1

@onready var player :TextureRect = $Player
@onready var controls := $Controls


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_id < 0:
		push_error("Player ID not set for PlayerControlsDisplay")
		queue_free()
		return
		
	var player_sprite_path := PlayerInput.get_sprite_for_player_icon(player_id)
	player.texture = player_sprite_path
	
	var action_sprite_paths := PlayerInput.get_all_distinct_sprites_for_player(player_id)
	for action_sprite_path in action_sprite_paths:
		var texture_rect := TextureRect.new()
		texture_rect.texture = action_sprite_path
		controls.add_child(texture_rect)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
