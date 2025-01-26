class_name Background
extends Node2D


var _deco_scene: PackedScene = preload("res://background/background_deco.tscn")


func _ready() -> void:
	for i in 50:
		var deco := _deco_scene.instantiate()
		add_child(deco)
