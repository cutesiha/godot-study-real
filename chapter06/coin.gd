extends Area2D

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	# 회전 애니메이션으로 먹을 수 있는 오브젝트라는 것을 눈에 띄게 한다.
	sprite.rotation += deg_to_rad(180.0) * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		queue_free()
