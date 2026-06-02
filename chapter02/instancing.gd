extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_scene: PackedScene = load("res://chapter02/Player.tscn")
	var player: CharacterBody2D = player_scene.instantlate()
	add_child(player)
