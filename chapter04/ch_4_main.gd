# res://Chapter04/ch_4_main.gd
extends Node2D

# 자주 쓸 노드는 미리 변수에 담아둔다 (캐싱)
@onready var player: CharacterBody2D = $Player
@onready var coin: Area2D = $Coin
@onready var score_label: Label = $UI/ScoreLabel

var score := 0

func _ready() -> void:
	# 코인의 body_entered 시그널을 핸들러에 연결
	coin.body_entered.connect(_on_coin_body_entered)
	score_label.text = "Score: 0"

# 시그널 핸들러: 코인에 무언가 들어오면 자동 호출된다
func _on_coin_body_entered(body: Node2D) -> void:
	# 들어온 것이 플레이어일 때만 점수 처리
	if body == player:
		score += 1
		score_label.text = "Score: %d" % score
		coin.queue_free()  # 코인 제거 → coin의 _exit_tree 호출됨

func _exit_tree() -> void:
	# 게임 종료 시 시그널 해제 (메모리 누수 방지)
	if is_instance_valid(coin) and coin.body_entered.is_connected(_on_coin_body_entered):
		coin.body_entered.disconnect(_on_coin_body_entered)
