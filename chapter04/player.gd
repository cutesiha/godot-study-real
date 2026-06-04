extends CharacterBody2D

@onready var image: Sprite2D = $Sprite2D
signal health_changed(hp: int)

func _ready() -> void:
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)

	health_changed.emit(10)
	print("Player가 Signal 보냄")

func _on_mouse_entered() -> void:
	health_changed.emit(10)
	print("Player mouse entered!!")

func _process(delta: float) -> void:
	# delta를 곱해 "초당 90도" 회전 → FPS가 달라도 회전 속도 동일
	# image.rotation += deg_to_rad(90) * delta
	pass
	
const SPEED := 200.0

func _physics_process(delta: float) -> void:
	# 입력값을 받아 방향 벡터로 변환
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * SPEED
	move_and_slide()  # 충돌 포함 이동은 반드시 여기서
