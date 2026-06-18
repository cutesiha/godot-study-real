# AGENTS.md - Godot 학습 프로젝트 규칙

## 프로젝트
- Godot 4.6.3 게임 제작 학습용 프로젝트

## 폴더 구조
- 각 챕터는 `chapterNN/` 폴더에 모든 파일을 보관한다.
- 예: `chapter03`의 모든 `.tscn`, `.gd`, `.png` 파일은 `chapter03/` 안에 둔다.
- 공통 자산은 필요할 때 `Assets/`에 둔다.
- 문서는 `docs/`에 둔다.

## 씬 컨벤션 (캐릭터)
캐릭터 씬은 항상 아래 구조로 만든다.

- 루트: `CharacterBody2D`, 노드 이름은 파일명과 동일한 파스칼 케이스로 한다. (`player.tscn` -> `Player`)
- 자식 1: `Sprite2D`, `texture`는 같은 폴더의 `.png`를 사용한다.
- 자식 2: `CollisionShape2D`, `shape`은 `RectangleShape2D`를 사용한다.
- 루트에 같은 이름의 `.gd` 스크립트를 attach한다. (`player.tscn` -> `player.gd`)

빈 스크립트는 항상 `extends <루트 노드 타입>` 한 줄로 시작한다.

## 파일 이름 규칙
- 씬, 스크립트, 이미지는 모두 소문자 snake_case로 작성한다.
- `Player.tscn` (X) -> `player.tscn` (O)

## 검증 명령
새 씬이나 스크립트를 만든 뒤에는 반드시 임포트를 돌린다.

```powershell
godot --headless --import
```

## 설명 주석 규칙
- 사용자가 기능 구현을 요청하면, 핵심 코드에는 왜 그렇게 구현했는지 한 줄 주석으로 설명한다.

## 하지 말 것
- Godot 에디터 GUI 클릭을 전제로 안내하지 않는다.
- Godot 3.x 문법을 사용하지 않는다. (`KinematicBody2D` 대신 Godot 4.x의 `CharacterBody2D` 사용)
- 영문 주석을 강제하지 않는다. 한글 주석을 적극 권장한다.
- 새 파일은 해당 챕터 폴더 밖에 만들지 않는다.
