extends Node2D

# 자주 쓸 노드는 미리 변수에 담아둔다 (캐싱)
@onready var player: CharacterBody2D = $Player
@onready var coin: Area2D = $Coin
@onready var score_label: Label = $UI/ScoreLabel

var score := 0

func _ready() -> void:
	score_label.text = "Score: 0"
	print("main_ready 호출됨!!")
	coin.body_entered.connect(_on_coin_body_entered)
	coin.body_exited.connect(_on_coin_body_exited)

func _on_coin_body_entered(body: Node2D) -> void:
	if body == player:
		score += 1
		score_label.text = "Score: %d" % score
		coin.queue_free()

func _exit_tree() -> void:
	if is_instance_valid(coin) and coin.body_entered.is_connected(_on_coin_body_entered):
		coin.body_entered.disconnect(_on_coin_body_entered)

	if is_instance_valid(coin) and coin.body_exited.is_connected(_on_coin_body_exited):
		coin.body_exited.disconnect(_on_coin_body_exited)

func _on_coin_body_exited(body: Node2D) -> void:
	# print("body_exited 이벤트 발생!!")
	pass
