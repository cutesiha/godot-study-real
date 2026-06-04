extends Node2D

@onready var player = $Player
@onready var score_label: Label = $CanvasLayer/ScoreLabel

func _ready() -> void:
	player.health_changed.connect(_on_player_health_changed)
	score_label.text = "준비 완료"
	print("main ready 호출 됨")

func _on_player_health_changed(hp: int) -> void:
	print("Player에게 받은 hp: ", hp)
