extends Area2D

var speed := 720.0
var direction := Vector2.RIGHT
var life_time := 1.2


func setup(new_direction: Vector2, power: float) -> void:
	# 충전 시간에 따라 탄 크기와 속도를 키워서 차지 샷의 강약이 보이게 한다.
	direction = new_direction.normalized()
	scale = Vector2.ONE * power
	speed *= power


func _physics_process(delta: float) -> void:
	# 발사체는 충돌 처리보다 입력 예제용 시각화가 목적이라 정해진 방향으로 단순 이동시킨다.
	position += direction * speed * delta
	life_time -= delta

	if life_time <= 0.0:
		queue_free()
