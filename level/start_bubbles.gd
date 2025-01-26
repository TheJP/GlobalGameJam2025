class_name StartBubbles
extends Node2D

@onready var bubbles: Array = get_children()

var music: AudioStreamPlayer2D
var playtime: float = 2.5
var timer: float = playtime

func _ready() -> void:
	print("StartBubbles ready")
	for bubble: Node in bubbles:
		print("Bubble: ", bubble)
		if bubble is CPUParticles2D:
			bubble.restart()
	music = Music.play_sound(Music.Sounds.Water_bubbles_start)


func _process(delta: float) -> void:
	timer -= delta
#	music.volume_db = timer / playtime
	if timer <= 0:
		music.stop()
		music.queue_free()
		print("StartBubbles finished")
		queue_free()
