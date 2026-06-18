extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const COYOTE_TIME := 0.25
const DASH_SPEED := 900.0
const DASH_TIME := 0.12
const DASH_COOLDOWN := 0.35
const MAX_CHARGE_TIME := 1.2
const SHOT_HEIGHT := -120.0
const SHOT_FORWARD_OFFSET := 75.0
const CHARGE_SHOT_SCENE := preload("res://chapter05/charge_shot.tscn")

var facing_direction := Vector2.RIGHT
var coyote_timer := 0.0
var can_coyote_jump := false
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var dash_direction := Vector2.RIGHT
var charge_time := 0.0


func _ready() -> void:
	# 프로젝트 설정에 액션이 없어도 예제가 바로 실행되도록 기본 키를 런타임에 등록한다.
	ensure_action_has_key("jump", KEY_SPACE)
	ensure_action_has_key("dash", KEY_SHIFT)
	ensure_action_has_key("charge_shot", KEY_R)


func _physics_process(delta: float) -> void:
	var was_on_floor := is_on_floor()
	var jump_pressed := Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept")

	update_timers(delta)
	update_coyote_timer(delta, was_on_floor)
	handle_charge_shot(delta)

	if not was_on_floor:
		velocity += get_gravity() * delta

	handle_jump(jump_pressed, was_on_floor)

	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_key_pressed(KEY_A):
		direction -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction += 1.0

	direction = clampf(direction, -1.0, 1.0)
	if direction != 0.0:
		facing_direction = Vector2(signf(direction), 0.0)

	handle_dash(direction)

	if dash_timer > 0.0:
		# 대시 중에는 짧은 시간 동안 일반 이동보다 대시 속도를 우선 적용한다.
		velocity.x = dash_direction.x * DASH_SPEED
		move_and_slide()
		return

	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func handle_jump(jump_pressed: bool, was_on_floor: bool) -> void:
	# 점프는 누른 순간 입력만 받아야 길게 누르고 있어도 여러 번 발동하지 않는다.
	if not jump_pressed:
		return

	if was_on_floor:
		perform_jump()
		return

	if can_coyote_jump and coyote_timer > 0.0:
		perform_jump()


func perform_jump() -> void:
	# 점프가 한 번 발동되면 코요테 허가권을 닫아서 공중에서 딱 한 번만 가능하게 한다.
	velocity.y = JUMP_VELOCITY
	coyote_timer = 0.0
	can_coyote_jump = false


func handle_dash(direction: float) -> void:
	# 대시는 누른 순간의 방향을 상태로 저장해야 발동 중 방향이 흔들리지 않는다.
	if not Input.is_action_just_pressed("dash") or dash_cooldown_timer > 0.0:
		return

	if direction != 0.0:
		dash_direction = Vector2(signf(direction), 0.0)
	else:
		dash_direction = facing_direction

	dash_timer = DASH_TIME
	dash_cooldown_timer = DASH_COOLDOWN
	velocity.y = 0.0


func handle_charge_shot(delta: float) -> void:
	# 차지 샷은 누르는 동안 시간을 모으고 뗀 순간 모은 힘으로 발사한다.
	if Input.is_action_pressed("charge_shot"):
		charge_time = minf(charge_time + delta, MAX_CHARGE_TIME)

	if Input.is_action_just_released("charge_shot") and charge_time > 0.0:
		fire_charge_shot()
		charge_time = 0.0


func fire_charge_shot() -> void:
	# 발사체는 플레이어 원점이 아니라 실제 그림의 손/가슴 높이에서 나오도록 보정한다.
	var shot := CHARGE_SHOT_SCENE.instantiate()
	var power := lerpf(1.0, 2.4, charge_time / MAX_CHARGE_TIME)
	get_parent().add_child(shot)
	shot.global_position = global_position + Vector2(facing_direction.x * SHOT_FORWARD_OFFSET, SHOT_HEIGHT)
	shot.setup(facing_direction, power)


func update_timers(delta: float) -> void:
	# 대시 시간과 쿨다운은 프레임마다 줄여야 순간 발동 후 상태가 자연스럽게 끝난다.
	dash_timer = maxf(dash_timer - delta, 0.0)
	dash_cooldown_timer = maxf(dash_cooldown_timer - delta, 0.0)


func update_coyote_timer(delta: float, was_on_floor: bool) -> void:
	# 타이머는 바닥에 있을 때 채우고 떨어진 뒤에는 줄여서 짧은 유예 시간만 만든다.
	if was_on_floor:
		coyote_timer = COYOTE_TIME
		can_coyote_jump = true
	else:
		coyote_timer = maxf(coyote_timer - delta, 0.0)
		if coyote_timer <= 0.0:
			can_coyote_jump = false


func ensure_action_has_key(action_name: StringName, keycode: Key) -> void:
	# InputMap에 기본 키가 없을 때만 추가해서 사용자가 바꾼 키를 덮어쓰지 않는다.
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	if InputMap.action_get_events(action_name).is_empty():
		var event := InputEventKey.new()
		event.keycode = keycode
		InputMap.action_add_event(action_name, event)
