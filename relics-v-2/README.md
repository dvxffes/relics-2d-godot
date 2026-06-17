# RELICS — 유물이 된 세계

## 열기
압축 해제 후 Godot 4.x에서 `project.godot` 열기
(Autoload는 project.godot에 이미 등록되어 있음)

## 씬 구조
```
MainMenu.tscn       ← 시작 화면
GameWorld.tscn      ← 메인 플레이 (탑뷰)
  ├ Player          ← WASD 이동
  ├ DigSite1~3      ← 발굴 가능 칸 (✦ 표시)
  ├ Codex           ← 도감 UI (E키)
  ├ Tutorial        ← 튜토리얼
  └ HUD             ← 화면 상단 힌트
RelicPopup.tscn     ← 유물 복원 미니게임 팝업
```

## 조작
| 키 | 동작 |
|---|---|
| WASD | 이동 |
| Space / Enter | 발굴 상호작용 (3회) |
| E | 도감 열기/닫기 |
| 마우스 드래그 | 유물 닦기 (팝업) |

## 발굴지 추가하기
GameWorld.tscn에서 DigSite1을 복사 → relic_id를 GameData.gd의 id와 맞게 수정

## 유물 추가하기
GameData.gd의 RELICS 배열에 항목 추가:
```gdscript
{
	"id": "new_relic",
	"name": "유물 이름",
	"desc": "설명 텍스트",
	"color": Color(0.5, 0.3, 0.2)
}
```

## 알려진 제한
- GPUParticles2D의 process_material은 에디터에서 ParticleProcessMaterial을 
  직접 할당해야 흙 파티클이 보임 (없어도 게임은 동작함)
- 유물 이미지는 ColorRect로 표현됨 (추후 Sprite2D로 교체 가능)
