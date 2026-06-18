# TASKS.md — Chapter06 구현 순서와 검수 체크리스트

## 0. 작업 원칙

- 한 번에 전체 게임을 완성하려고 하지 않는다.
- 기능을 작은 단계로 나누어 구현한다.
- Codex는 코드 작성과 구조 정리에 사용한다.
- Godot 에디터에서는 위치, 크기, 충돌 모양, 물리 감각, 점프 거리, 발판 이동 거리를 직접 조정한다.
- 각 단계가 끝나면 반드시 Godot에서 실행하여 검수한다.

---

## 1단계. Chapter06 폴더 구조 만들기

### 작업 내용

`res://Chapter06/` 아래에 다음 구조를 만든다.

```text
Chapter06/
├─ GAME_SPEC.md
├─ TASKS.md
├─ scenes/
├─ scripts/
└─ assets/
```

### 검수 방법

- `Chapter06` 폴더 안에 필요한 하위 폴더가 있는지 확인한다.
- 다른 Chapter 폴더에 새 파일이 생기지 않았는지 확인한다.

---

## 2단계. Input Map 설정

### 작업 내용

Godot 에디터에서 Project Settings > Input Map에 다음 액션을 추가한다.

- `move_left`: A, ←
- `move_right`: D, →
- `jump`: Space
- `reset`: R

### 검수 방법

- 각 액션이 정확한 이름으로 등록되어 있는지 확인한다.
- 액션명 오타가 없는지 확인한다.

### Godot에서 직접 하는 것이 좋은 작업

Input Map 등록은 Codex보다 Godot 에디터에서 직접 하는 것이 더 빠르고 안전하다.

---

## 3단계. Main.tscn 기본 구조 만들기

### 작업 내용

`res://Chapter06/scenes/main.tscn`을 만든다.

권장 노드 구조:

```text
Main (Node2D)
├─ World (Node2D)
│  ├─ StartBox (StaticBody2D)
│  ├─ Floor (StaticBody2D)
│  ├─ LeftWall (StaticBody2D)
│  └─ RightWall (StaticBody2D)
├─ Player (CharacterBody2D)
├─ Ball (RigidBody2D)
├─ MovingPlatform (AnimatableBody2D)
├─ Coins (Node2D)
│  ├─ Coin1 (Area2D)
│  └─ Coin2 (Area2D)
├─ UI (CanvasLayer)
│  ├─ CoinLabel (Label)
│  ├─ ResetLabel (Label)
│  └─ ClearLabel (Label)
└─ GameManager (Node)
```

### 검수 방법

- Main 씬이 실행되는지 확인한다.
- 한 화면 안에 StartBox, Floor, MovingPlatform이 보이는지 확인한다.
- 카메라 이동 없이 전체 구조가 보이는지 확인한다.

---

## 4단계. 지형 배치하기

### 작업 내용

다음 고정 지형을 배치한다.

- StartBox
- Floor
- LeftWall
- RightWall

### 배치 조건

- StartBox는 왼쪽에 높게 배치한다.
- Floor는 화면 아래쪽 전체를 막는다.
- 좌우 벽은 Ball이 화면 밖으로 나가지 않도록 배치한다.
- StartBox 오른쪽 끝은 Ball이 떨어질 수 있도록 열려 있어야 한다.

### 검수 방법

- Ball이 떨어질 공간이 있는지 확인한다.
- Floor와 Walls의 `CollisionShape2D`가 화면을 적절히 막는지 확인한다.
- `Visible Collision Shapes`를 켜고 충돌 모양을 확인한다.

### Godot에서 직접 하는 것이 좋은 작업

지형 위치, 크기, `CollisionShape2D` 조정은 Godot 에디터에서 직접 하는 것이 좋다.

---

## 5단계. Player 이동과 1단 점프 구현

### 작업 내용

`res://Chapter06/scripts/player.gd`를 작성한다.

구현 기능:

- 좌우 이동
- 중력 적용
- 1단 점프
- 공중 추가 점프 방지
- `move_and_slide()` 사용
- 클리어 후 이동과 점프 입력 차단 가능하도록 처리

### 검수 방법

- A/D 또는 방향키로 좌우 이동이 되는지 확인한다.
- Space로 점프가 되는지 확인한다.
- 공중에서 추가 점프가 되지 않는지 확인한다.
- StartBox 위에서 MovingPlatform까지 점프로 도달 가능한지 확인한다.
- 바닥에서는 MovingPlatform으로 바로 올라갈 수 없는지 확인한다.

### Godot에서 직접 하는 것이 좋은 작업

Player의 이동 속도, 점프 높이, 충돌 크기는 실행하면서 직접 조정한다.

---

## 6단계. Ball 물리 구현

### 작업 내용

Ball을 `RigidBody2D`로 만든다.

구현 조건:

- Player가 밀 수 있어야 한다.
- StartBox 오른쪽 끝에서 바닥으로 떨어져야 한다.
- 바닥에서 3~5번 정도 튀어야 한다.
- 굴러가다가 마찰과 감속으로 점점 멈춰야 한다.
- 벽에 닿으면 반대 방향으로 튕겨야 한다.
- 바닥에 떨어진 후에도 Player가 다시 밀 수 있어야 한다.

### 검수 방법

- Player가 Ball을 밀 수 있는지 확인한다.
- Ball이 StartBox 오른쪽 끝에서 자연스럽게 떨어지는지 확인한다.
- Ball이 바닥에서 통통 튀는지 확인한다.
- Ball이 너무 멀리 날아가지 않는지 확인한다.
- Ball이 화면 절반 정도를 굴러간 뒤 멈추는 느낌인지 확인한다.

### Godot에서 직접 하는 것이 좋은 작업

Ball의 `Mass`, `Bounce`, `Friction`, `Linear Damp`, `Angular Damp` 값은 Godot 에디터에서 직접 조정한다.

---

## 7단계. Coin 획득 구현

### 작업 내용

Coin을 `Area2D`로 만든다.

구현 조건:

- Coin1은 StartBox 위, Ball의 오른쪽에 배치한다.
- Coin2는 MovingPlatform 위쪽 공중에 고정한다.
- Coin2는 MovingPlatform과 함께 움직이지 않는다.
- Player가 닿았을 때만 코인이 사라진다.
- Ball, Platform, Wall, Floor가 닿아도 코인은 사라지지 않는다.
- 코인을 먹으면 GameManager에 알린다.

### 검수 방법

- Player가 Coin1을 먹으면 사라지는지 확인한다.
- Ball이 Coin1에 닿아도 Coin1이 사라지지 않는지 확인한다.
- Player가 Coin2를 먹으면 사라지는지 확인한다.
- Coin2가 MovingPlatform과 함께 움직이지 않는지 확인한다.

---

## 8단계. MovingPlatform 구현

### 작업 내용

MovingPlatform을 `AnimatableBody2D`로 만든다.

구현 조건:

- 오른쪽 공중에 배치한다.
- 게임 시작 시 왼쪽 지점에서 출발한다.
- 좌우로 짧게 왕복한다.
- 양 끝에서 각각 0.5초 멈춘다.
- Player가 위에 서 있으면 발판과 함께 이동한다.

### 검수 방법

- 발판이 좌우로 왕복하는지 확인한다.
- 양 끝에서 0.5초 정도 멈추는지 확인한다.
- Player가 발판 위에 서 있을 때 함께 이동하는지 확인한다.
- StartBox에서는 발판에 점프해서 도달 가능한지 확인한다.
- 바닥에서는 발판으로 바로 올라갈 수 없는지 확인한다.

### Godot에서 직접 하는 것이 좋은 작업

발판 위치, 이동 거리, 속도는 Godot 에디터에서 직접 조정한다.

---

## 9단계. UI 구현

### 작업 내용

UI를 `CanvasLayer` 아래에 구성한다.

필요 UI:

- `CoinLabel`: `Coin 0/2`
- `ResetLabel`: `R Reset`
- `ClearLabel`: `CLEAR!`

초기 상태:

- `CoinLabel` 표시
- `ResetLabel` 표시
- `ClearLabel` 숨김

### 검수 방법

- 게임 시작 시 `Coin 0/2`가 보이는지 확인한다.
- R Reset 안내가 보이는지 확인한다.
- 처음에는 CLEAR 문구가 보이지 않는지 확인한다.

### Godot에서 직접 하는 것이 좋은 작업

UI 위치, 글자 크기, 정렬은 Godot 에디터에서 직접 조정한다.

---

## 10단계. GameManager 구현

### 작업 내용

`res://Chapter06/scripts/game_manager.gd`를 작성한다.

관리할 상태:

- `coin_count`
- `total_coin`
- `is_clear`

구현 기능:

- 코인 획득 시 카운트 증가
- CoinLabel 갱신
- 코인 2개 획득 시 ClearLabel 표시
- 클리어 후 Player 이동과 점프 입력 차단
- R키 입력 시 현재 씬 다시 불러오기

### 검수 방법

- Coin1을 먹으면 `Coin 1/2`가 되는지 확인한다.
- Coin2를 먹으면 `Coin 2/2`가 되는지 확인한다.
- 코인 2개를 먹으면 `CLEAR!`가 표시되는지 확인한다.
- 클리어 후 Player 이동과 점프가 막히는지 확인한다.
- 클리어 후에도 R키 리셋이 되는지 확인한다.

---

## 11단계. R키 리셋 구현

### 작업 내용

R키를 누르면 현재 씬을 다시 불러온다.

기대 동작:

- Player 초기 위치로 복귀
- Ball 초기 위치로 복귀
- Coin1, Coin2 다시 나타남
- MovingPlatform 초기 위치로 복귀
- UI가 `Coin 0/2` 상태로 복귀

### 검수 방법

- 바닥에 떨어진 뒤 R키를 누르면 처음부터 다시 시작되는지 확인한다.
- 클리어 후 R키를 눌러도 다시 시작되는지 확인한다.

---

## 12단계. 전체 통합 검수

### 최종 체크리스트

#### 기본 실행

- [ ] Main 씬이 오류 없이 실행된다.
- [ ] 화면이 1280×720 한 화면 구조로 보인다.

#### Player

- [ ] 좌우 이동이 된다.
- [ ] 1단 점프가 된다.
- [ ] 공중 추가 점프가 되지 않는다.
- [ ] StartBox에서 MovingPlatform까지 점프 가능하다.
- [ ] 바닥에서는 MovingPlatform으로 바로 올라갈 수 없다.

#### Ball

- [ ] Player가 Ball을 밀 수 있다.
- [ ] Ball이 StartBox 오른쪽 끝에서 떨어진다.
- [ ] Ball이 바닥에서 3~5번 정도 튄다.
- [ ] Ball이 굴러가다가 점점 멈춘다.
- [ ] Ball이 벽에 닿으면 반대로 튕긴다.

#### Coin

- [ ] Player가 Coin1을 먹을 수 있다.
- [ ] Ball이 Coin에 닿아도 Coin이 사라지지 않는다.
- [ ] Player가 Coin2를 먹을 수 있다.
- [ ] Coin2는 MovingPlatform과 함께 움직이지 않는다.

#### MovingPlatform

- [ ] 좌우로 왕복한다.
- [ ] 양 끝에서 0.5초 정도 멈춘다.
- [ ] Player가 위에 서 있으면 함께 이동한다.

#### Reset / Clear

- [ ] R키를 누르면 전체 씬이 초기화된다.
- [ ] 코인 2개를 모두 먹으면 `CLEAR!`가 표시된다.
- [ ] 클리어 후 Player 이동과 점프가 막힌다.
- [ ] 클리어 후에도 R키 리셋이 가능하다.

---

## 13단계. 마무리 조정

### 조정할 항목

- Player 이동 속도
- Player 점프 높이
- Ball의 튐 정도
- Ball의 마찰과 감속
- MovingPlatform 이동 거리
- MovingPlatform 이동 속도
- Coin2 위치
- UI 위치와 크기

### 최종 목표

- 공은 바닥에서 통통 튀고 굴러가는 모습이 잘 보여야 한다.
- 발판 도전은 너무 쉽지도, 너무 어렵지도 않아야 한다.
- 코인 2개를 먹는 흐름이 자연스러워야 한다.
- 실패했을 때 R키로 다시 시작하는 구조가 명확해야 한다.
