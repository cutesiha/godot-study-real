# res://Chapter04/Coin.gd
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	# delta를 곱해 "초당 180도" 회전 → FPS가 달라도 회전 속도 동일
	sprite.rotation += deg_to_rad(180) * delta
