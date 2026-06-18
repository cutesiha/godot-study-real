extends CharacterBody2D

const SPEED := 260.0
const JUMP_VELOCITY := -520.0
const PUSH_POWER := 520.0
const DEATH_TIME := 1.45
const DEADLY_GROUND_NAME := "Ground"

var can_double_jump := false
var is_dying := false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	ensure_action_has_key("jump", KEY_SPACE)


func _physics_process(delta: float) -> void:
	if is_dying:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_key_pressed(KEY_A):
		direction -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction += 1.0
	direction = clampf(direction, -1.0, 1.0)

	if is_on_floor():
		can_double_jump = true

	if Input.is_action_just_pressed("jump") and is_on_floor():
		# 바닥 점프 뒤에 공중 점프 1번을 남겨서 발판까지 자연스럽게 닿게 한다.
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and can_double_jump:
		# 공중에서는 한 번만 추가 점프하게 해서 무한 점프가 되지 않게 막는다.
		velocity.y = JUMP_VELOCITY
		can_double_jump = false

	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	move_and_slide()
	if is_touching_deadly_ground():
		start_death()
	else:
		push_ball_if_touching(direction)


func push_ball_if_touching(direction: float) -> void:
	if direction == 0.0:
		return

	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		if body != null and body.has_method("kick_from_player"):
			# 캐릭터 바디를 직접 밀지 않고, 공에게 별도 속도를 전달한다.
			body.kick_from_player(signf(direction), PUSH_POWER)


func is_touching_deadly_ground() -> bool:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		if body != null and body.name == DEADLY_GROUND_NAME and collision.get_normal().y < -0.6:
			return true

	return false


func start_death() -> void:
	is_dying = true
	velocity = Vector2.ZERO
	collision_shape.set_deferred("disabled", true)

	var transparent := sprite.modulate
	transparent.a = 0.0

	# 아래 바닥은 사망 구역이라 입력을 끊고 90도로 쓰러지며 천천히 사라지게 한다.
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "rotation", deg_to_rad(90.0), DEATH_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "modulate", transparent, DEATH_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.finished.connect(queue_free)


func ensure_action_has_key(action_name: StringName, keycode: Key) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	if InputMap.action_get_events(action_name).is_empty():
		var event := InputEventKey.new()
		event.keycode = keycode
		InputMap.action_add_event(action_name, event)
