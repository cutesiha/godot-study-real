# AGENTS.md — Chapter06 전용 규칙

이 문서는 `res://Chapter06/` 폴더 안에서만 적용할 Chapter06 전용 작업 규칙이다.  
전체 공통 규칙은 `res://AGENTS.md`를 따른다.

---

## 1. 작업 범위

- 이번 작업 범위는 `res://Chapter06/`이다.
- `Chapter01` ~ `Chapter05` 폴더의 파일은 요청 없이 수정하지 않는다.
- Chapter06의 게임 기획은 `GAME_SPEC.md`를 기준으로 한다.
- Chapter06의 구현 순서와 체크리스트는 `TASKS.md`를 기준으로 한다.

---

## 2. Chapter06 게임 기준

Chapter06은 Godot 4.6으로 만드는 2D 물리 플랫폼 미니게임이다.

- Player는 높은 시작 박스 위에서 시작한다.
- Ball은 Player가 밀면 시작 박스 오른쪽 끝에서 떨어진다.
- Ball은 바닥에서 튀고 굴러가다가 점점 멈춘다.
- Coin은 총 2개이다.
- MovingPlatform은 오른쪽 공중에서 좌우로 왕복한다.
- Player는 시작 박스에서 MovingPlatform까지 점프할 수 있다.
- 바닥으로 떨어지면 R키로 현재 씬을 다시 시작한다.
- 복귀 발판과 ballOnlyWall은 사용하지 않는다.

자세한 게임 규칙은 항상 `GAME_SPEC.md`를 우선 확인한다.

---

## 3. 노드 사용 기준

- Player: `CharacterBody2D`
- Ball: `RigidBody2D`
- Coin1 / Coin2: `Area2D`
- MovingPlatform: `AnimatableBody2D`
- StartBox / Floor / Wall: `StaticBody2D`
- UI: `CanvasLayer` + `Label`
- GameManager: `Node`

---

## 4. 파일 위치

Chapter06에서 새로 만드는 파일은 다음 위치에 둔다.

- 씬: `res://Chapter06/scenes/`
- 스크립트: `res://Chapter06/scripts/`
- 이미지: `res://Chapter06/assets/`

파일 이름은 소문자 `snake_case`를 사용한다.

예:

```text
main.tscn
player.tscn
player.gd
ball.tscn
ball.gd
moving_platform.gd
game_manager.gd
```

---

## 5. 구현 방식

- 한 번에 전체 게임을 만들지 않는다.
- `TASKS.md`의 단계 순서에 따라 하나씩 구현한다.
- 기능 하나를 구현한 뒤에는 Godot에서 실행해 검수한다.
- 코드에는 필요한 경우 한글 주석을 작성한다.
- 주석은 “무엇을 하는지”보다 “왜 이렇게 하는지”를 짧게 설명한다.

---

## 6. Godot 에디터에서 직접 조정할 것

다음 항목은 Codex보다 Godot 에디터에서 직접 조정하는 것이 좋다.

- StartBox, Floor, Wall의 위치와 크기
- Player의 CollisionShape 크기
- Ball의 Mass, Bounce, Friction, Linear Damp, Angular Damp
- MovingPlatform의 위치, 이동 거리, 이동 속도
- Coin1, Coin2의 정확한 위치
- UI Label의 위치와 크기

---

## 7. 검수 원칙

작업 후에는 다음을 알려준다.

- 수정한 파일 목록
- Godot에서 실행할 씬
- 테스트할 입력
- 정상 동작 기준
- Godot 에디터에서 직접 조정해야 할 항목
