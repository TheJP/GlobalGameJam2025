class_name Dropper
extends Node2D


var dropping_scene: PackedScene = preload("res://enemies/dropper/dropping.tscn")


func _on_shoot_cooldown_timeout() -> void:
	var dropping: Dropping = dropping_scene.instantiate()
	dropping.global_position = global_position
	get_parent().add_child(dropping)
