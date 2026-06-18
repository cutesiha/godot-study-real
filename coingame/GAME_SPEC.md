# GAME_SPEC.md — Chapter06 2D 물리 플랫폼 미니게임 기획서

## 1. 게임 개요

이 게임은 Godot 4.6으로 만드는 2D 물리 플랫폼 미니게임이다.

Player는 왼쪽의 높은 시작 박스 위에서 시작한다.  
시작 박스 위에는 Player, Ball, Coin1이 있다.  
Player가 Ball을 밀면 Ball은 시작 박스 오른쪽 끝에서 아래 바닥으로 떨어지고, 바닥에서 통통 튄 뒤 굴러가다가 점점 멈춘다.  
Player는 시작 박스에서 점프해 오른쪽의 MovingPlatform에 올라타고, 두 번째 코인을 먹어야 한다.

코인 2개를 모두 먹으면 `CLEAR!`가 표시된다.

---

## 2. 화면 / 맵 구조

- 화면 크기는 1280×720 기준이다.
- 카메라는 움직이지 않는다.
- 전체 게임은 한 화면 안에서 진행된다.
- 왼쪽에는 높은 `StartBox`가 있다.
- 오른쪽 공중에는 좌우로 움직이는 `MovingPlatform`이 있다.
- 아래에는 Ball이 떨어져 튀고 굴러가는 `Floor`가 있다.
- 좌우에는 Ball이 화면 밖으로 나가지 않도록 벽이 있다.
- 복귀 발판은 없다.
- `ballOnlyWall` 같은 공 전용 보이지 않는 벽도 사용하지 않는다.

---

## 3. Player 규칙

- Player는 `CharacterBody2D`로 만든다.
- Player는 시작 박스 위에서 시작한다.
- Player는 좌우 이동과 1단 점프를 할 수 있다.
- Player는 바닥, 시작 박스, 움직이는 발판, 공 위에 서 있을 때만 1단 점프할 수 있다.
- 공중에서는 추가 점프를 할 수 없다.
- Player는 시작 박스에서 점프하여 MovingPlatform에 도달할 수 있어야 한다.
- Player가 타이밍을 놓치면 바닥으로 떨어진다.
- Player가 바닥으로 떨어져도 자동으로 죽지는 않는다.
- 하지만 바닥에서는 시작 박스나 MovingPlatform으로 다시 올라갈 수 없다.
- 따라서 실패하면 R키를 눌러 현재 씬을 다시 시작한다.
- 클리어 후에는 Player의 이동과 점프 입력을 막는다.
- 클리어 후에도 R키 리셋은 가능하다.

---

## 4. Ball 규칙

- Ball은 `RigidBody2D`로 만든다.
- Ball은 시작 박스 위에 배치한다.
- Ball은 Player의 오른쪽에 있다.
- Player가 Ball을 밀면 Ball은 시작 박스 오른쪽 끝에서 아래 바닥으로 떨어진다.
- Ball은 바닥에서 3~5번 정도 통통 튄다.
- Ball은 바닥에서 굴러가다가 마찰과 감속으로 점점 멈춘다.
- Ball은 벽에 맞으면 반대 방향으로 튕긴다.
- Ball은 바닥에 떨어진 뒤에도 Player가 다시 밀면 굴러갈 수 있다.
- Ball은 너무 세게 날아가지 않고, 대략 화면의 절반 정도를 이동하면 멈추는 느낌으로 조정한다.
- Ball은 코인을 먹지 못한다.
- Ball은 클리어 조건에 포함되지 않는다.
- Ball의 목적은 물리 움직임을 관찰하는 학습 요소이다.

---

## 5. Coin 규칙

- 코인은 총 2개이다.
- Coin1은 시작 박스 위에 있다.
- Coin1은 Ball의 오른쪽에 둔다.
- Player는 오른쪽으로 이동하면서 Ball을 밀고, 이어서 Coin1을 자연스럽게 먹는다.
- Coin2는 MovingPlatform 위쪽 공중에 고정되어 있다.
- Coin2는 MovingPlatform과 함께 움직이지 않는다.
- 코인은 Player가 닿았을 때만 획득된다.
- Ball, MovingPlatform, 벽, 바닥이 코인에 닿아도 코인은 사라지지 않는다.
- 코인을 먹으면 화면의 코인 카운트가 증가한다.
- 코인 2개를 모두 먹으면 즉시 클리어된다.

---

## 6. MovingPlatform 규칙

- MovingPlatform은 `AnimatableBody2D`로 만든다.
- MovingPlatform은 오른쪽 공중에 배치한다.
- MovingPlatform은 게임 시작 시 왼쪽 지점에서 출발한다.
- MovingPlatform은 좌우로 짧게 왕복한다.
- MovingPlatform은 양 끝에서 각각 0.5초 멈춘 뒤 반대 방향으로 이동한다.
- Player가 MovingPlatform 위에 서 있으면 발판과 함께 이동한다.
- MovingPlatform은 시작 박스에서는 점프로 도달 가능해야 한다.
- MovingPlatform은 바닥에서는 점프로 바로 올라갈 수 없어야 한다.

---

## 7. 입력 규칙

Input Map에는 다음 액션을 사용한다.

- `move_left`: A, ←
- `move_right`: D, →
- `jump`: Space
- `reset`: R

---

## 8. UI 규칙

- 화면 왼쪽 위에 코인 카운트를 표시한다.
  - 예: `Coin 0/2`, `Coin 1/2`, `Coin 2/2`
- 화면 오른쪽 위에 `R Reset` 안내를 표시한다.
- 처음에는 `CLEAR!` 문구를 숨긴다.
- 코인 2개를 모두 먹으면 화면 중앙에 `CLEAR!`를 표시한다.

---

## 9. 클리어 / 리셋 규칙

- 코인 2개를 모두 먹으면 클리어된다.
- 클리어 후 Player의 이동과 점프 입력은 막는다.
- 클리어 후에도 Ball과 MovingPlatform의 물리는 계속 유지한다.
- R키를 누르면 현재 씬을 다시 불러온다.
- R키 리셋 시 Player, Ball, Coin, MovingPlatform, UI가 모두 처음 상태로 돌아간다.

---

## 10. 구현 노드 기준

- Player: `CharacterBody2D`
- Ball: `RigidBody2D`
- Coin1 / Coin2: `Area2D`
- MovingPlatform: `AnimatableBody2D`
- StartBox / Floor / Wall: `StaticBody2D`
- UI: `CanvasLayer` + `Label`
- GameManager: `Node`

---

## 11. 제거된 요소

이번 최종 기획에서는 다음 요소를 사용하지 않는다.

- 복귀 발판
- 아래 복귀 구간
- 낮은 벽
- Ball 전용 보이지 않는 벽
- 공 전용 구간 분리 구조
- 공을 반드시 밀어야만 코인을 먹을 수 있는 강제 퍼즐 구조
