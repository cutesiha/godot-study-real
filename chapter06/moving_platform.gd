extends AnimatableBody2D

@export var travel_distance := 260.0
@export var speed := 120.0

var start_position := Vector2.ZERO
var elapsed_time := 0.0


func _ready() -> void:
	start_position = position


func _physics_process(delta: float) -> void:
	elapsed_time += delta
	var cycle := elapsed_time * speed / travel_distance
	# 사인 곡선을 써서 오른쪽 끝과 왼쪽 끝 사이를 자연스럽게 계속 왕복하게 한다.
	position.x = start_position.x + sin(cycle) * travel_distance
