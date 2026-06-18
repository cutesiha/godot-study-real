extends Node2D

@onready var guide_label: Label = $CanvasLayer/GuideLabel
@onready var rebind_label: Label = $CanvasLayer/RebindLabel
@onready var jump_rebind_button: Button = $CanvasLayer/JumpRebindButton

var waiting_for_jump_key := false


func _ready() -> void:
	# 버튼 신호를 코드에서 연결하면 씬 파일을 직접 읽어도 동작 흐름이 보인다.
	jump_rebind_button.pressed.connect(_on_jump_rebind_button_pressed)
	jump_rebind_button.focus_mode = Control.FOCUS_NONE
	ensure_action_has_key("jump", KEY_SPACE)
	_update_text()


func _input(event: InputEvent) -> void:
	if not waiting_for_jump_key:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		# 리바인딩은 가공된 액션이 아니라 실제 눌린 키를 잡아야 하므로 _input의 raw 이벤트를 쓴다.
		set_jump_key(event)
		waiting_for_jump_key = false
		_update_text()
		get_viewport().set_input_as_handled()


func _on_jump_rebind_button_pressed() -> void:
	# 버튼을 누른 뒤 다음 키 입력 하나만 점프 액션으로 갈아끼운다.
	waiting_for_jump_key = true
	rebind_label.text = "아무 키나 누르세요..."


func set_jump_key(event: InputEventKey) -> void:
	# action_erase_events 후 새 이벤트를 넣으면 jump 액션의 기존 키 매핑이 완전히 교체된다.
	var new_event := InputEventKey.new()
	new_event.keycode = event.keycode
	new_event.physical_keycode = event.physical_keycode
	InputMap.action_erase_events("jump")
	InputMap.action_add_event("jump", new_event)


func ensure_action_has_key(action_name: StringName, keycode: Key) -> void:
	# UI가 먼저 실행되어도 jump 액션이 존재하도록 기본 매핑을 보장한다.
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	if InputMap.action_get_events(action_name).is_empty():
		var event := InputEventKey.new()
		event.keycode = keycode
		InputMap.action_add_event(action_name, event)


func _update_text() -> void:
	# 화면 설명은 현재 입력 예제에서 확인할 조작만 짧게 보여준다.
	guide_label.text = "←/→ 또는 A/D: 이동\n점프: jump 액션\nShift: 대시\nR 길게 누르기 + 떼기: 차지 샷"
	rebind_label.text = "점프키: %s" % get_jump_key_text()


func get_jump_key_text() -> String:
	# InputMap에 들어 있는 첫 키 이벤트를 읽어 현재 점프키를 사용자에게 보여준다.
	for event in InputMap.action_get_events("jump"):
		if event is InputEventKey:
			var keycode: Key = event.keycode
			if keycode == KEY_NONE:
				keycode = event.physical_keycode
			return OS.get_keycode_string(keycode)

	return "없음"
