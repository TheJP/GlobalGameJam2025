extends Node2D

@export var audio_players: Dictionary

enum Sounds {
	Bubbles,
	Shoot,
	Reload,
	Pump,
	Air_release,
	Shoot_enemy,
	Being_shot_losing_air,
	Hit_ground,
	Hit_ceiling,
	Menu_click,
	Menu_hover,
}


func play_sound(sound: Sounds, sound_position: Vector2 = Vector2(0, 0), sound_parent: Node2D = null) -> AudioStreamPlayer2D:
	if _sounds.has(sound):
		var sound_info: SoundInfo = _sounds[sound]
		var sound_instance: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		sound_instance.stream = load(sound_info.sound_resource_path)
		sound_instance.bus = "SFX" if sound_info.is_sfx else "Music"
		sound_instance.global_position = sound_position
		if sound_parent == null:
			sound_parent = self
		if sound_instance.get_parent() != null:
			sound_instance.reparent(sound_parent)
		else:
			sound_parent.add_child(sound_instance)
		sound_instance.play()
		if not sound_info.is_loop:
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
	var is_loop: bool = false
	func _init(_sound: Sounds, _sound_resource_path: String, _is_sfx: bool = true, _is_loop: bool = false) -> void:
		self.sound = _sound
		self.sound_resource_path = "res://music/" + _sound_resource_path
		self.is_sfx = _is_sfx
		self.is_loop = _is_loop

var _sounds: Dictionary = {
	Sounds.Bubbles: SoundInfo.new(Sounds.Bubbles, "496242__kevinhilt__water_bubbles.wav", true, true),
	Sounds.Reload: SoundInfo.new(Sounds.Reload, "Reload.mp3", true),
	Sounds.Shoot: SoundInfo.new(Sounds.Shoot, "Shoot.mp3", true),
	Sounds.Pump: SoundInfo.new(Sounds.Pump, "Pump_neu.mp3", true),
	Sounds.Air_release: SoundInfo.new(Sounds.Air_release, "Air_release_new.mp3", true),
	Sounds.Shoot_enemy: SoundInfo.new(Sounds.Shoot_enemy, "Shoot_enemy.mp3", true),
	Sounds.Being_shot_losing_air: SoundInfo.new(Sounds.Being_shot_losing_air, "Being_shot_losing_air.mp3", true),
	Sounds.Hit_ground: SoundInfo.new(Sounds.Hit_ground, "Hit_ground.mp3", true),
	Sounds.Hit_ceiling: SoundInfo.new(Sounds.Hit_ceiling, "Hit_ceiling.mp3", true),
	Sounds.Menu_click: SoundInfo.new(Sounds.Menu_click, "Menu_click.mp3", true),
	Sounds.Menu_hover: SoundInfo.new(Sounds.Menu_hover, "Menu_hover.mp3", true),
}
