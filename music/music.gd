extends Node2D

@export var audio_players: Dictionary

enum Sounds {
	Bubbles,
	Bubble_blow_up,
	Bubble_pop,
	Shoot,
	Reload,
	Pump_up,
	Air_release,
	Hit_enemy,
	Being_hit,
	Hit_ground,
}


func play_sound(sound: Sounds, sound_position: Vector2 = Vector2(0, 0), sound_parent: Node2D = null) -> AudioStreamPlayer2D:
	if _sounds.has(sound):
		var sound_info: SoundInfo = _sounds[sound]
		var sound_instance: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		sound_instance.stream = load(sound_info.sound_resource_path)
		sound_instance.bus = "SFX" if sound_info.is_sfx else "Music"
		sound_instance.global_position = sound_position
		if sound_parent != null:
			if sound_instance.get_parent() != null:
				sound_instance.reparent(sound_parent)
			else:
				sound_parent.add_child(sound_instance)
		sound_instance.play()
		if sound_instance.stream.loop_mode == AudioStreamWAV.LOOP_DISABLED:
			sound_instance.finished.connect(func () -> void:
				sound_instance.queue_free()
				print("Sound finished: ", sound)
			)
		return sound_instance

	else:
		print("Sound not found: ", sound)
		return null

class SoundInfo:
	var sound: Sounds
	var sound_resource_path: String
	var is_sfx: bool = false
	func _init(_sound: Sounds, _sound_resource_path: String, _is_sfx: bool = true) -> void:
		self.sound = _sound
		self.sound_resource_path = _sound_resource_path
		self.is_sfx = _is_sfx

var _sounds: Dictionary = {
	Sounds.Bubbles: SoundInfo.new(Sounds.Bubbles, "res://music/496242__kevinhilt__water_bubbles.wav", true),
	Sounds.Reload: SoundInfo.new(Sounds.Reload, "res://music/363167__samsterbirdies__mag-reload.wav", true),
	Sounds.Shoot: SoundInfo.new(Sounds.Shoot, "res://music/212594__klankbeeld__loud-explosion-131231_04.wav", true),
}
