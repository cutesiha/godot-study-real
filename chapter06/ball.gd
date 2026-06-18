extends CharacterBody2D

const GRAVITY := 980.0
const FLOOR_BOUNCE := 0.86
const WALL_BOUNCE := 0.72
const FLOOR_FRICTION := 120.0
const AIR_DRAG := 0.993
const STOP_SPEED := 18.0
const SETTLE_FALL_SPEED := 70.0

@onready var sprite: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	velocity.x *= AIR_DRAG

	var collision := move_and_collide(velocity * delta)
	if collision:
		apply_bounce(collision, delta)

	if absf(velocity.x) < STOP_SPEED and absf(velocity.y) < STOP_SPEED:
		velocity = Vector2.ZERO

	sprite.rotation += velocity.x * delta * 0.035


func kick_from_player(direction: float, power: float) -> void:
	if direction == 0.0:
		return

	# 플레이어가 민 방향으로 속도를 넣고 살짝 띄워서 공을 찬 느낌을 만든다.
	velocity.x = direction * power
	velocity.y = -power * 0.28


func apply_bounce(collision: KinematicCollision2D, delta: float) -> void:
	var normal := collision.get_normal()
	if normal.y < -0.6:
		# 바닥 충돌은 별도 탄성값을 써서 공처럼 통통 튀게 한다.
		var fall_speed := absf(velocity.y)
		velocity.y = 0.0 if fall_speed < SETTLE_FALL_SPEED else -fall_speed * FLOOR_BOUNCE
		velocity.x = move_toward(velocity.x, 0.0, FLOOR_FRICTION * delta)
	else:
		# 벽이나 모서리는 반사 방향으로 튕기되 바닥보다 조금 덜 튀게 한다.
		velocity = velocity.bounce(normal) * WALL_BOUNCE
