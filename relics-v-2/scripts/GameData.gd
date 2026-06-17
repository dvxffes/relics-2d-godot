extends Node

# ─────────────────────────────────────────
# GameData.gd  (Autoload)
# 유물 정의 + 플레이어 수집 현황 관리
# ─────────────────────────────────────────

signal codex_updated

# 수집 현황 (relic_id -> true/false)
var collected: Dictionary = {}

# 유물 정의 목록
# color: 도감 아이콘 배경색 (Color)
const RELICS: Array[Dictionary] = [
	{
		"id": "golden_crown",
		"name": "금동관",
		"desc": "가야 시대 수장이 착용하던 금동제 관. 행소박물관 대표 소장품으로, 정교한 가지 장식이 특징이다.",
		"color": Color(0.9, 0.75, 0.1),
		"texture_clean": "res://assets/relics/금동관.png", 
		"texture_dirty": "res://assets/relics/금동관_흙.png"
	},
	{
		"id": "iron_armor",
		"name": "철제 갑옷",
		"desc": "5~6세기 가야 전사의 판갑옷. 작은 철판을 이어 붙인 구조로, 당시 높은 철기 제작 기술을 보여준다.",
		"color": Color(0.45, 0.45, 0.5),
		"texture_clean": "res://assets/relics/철제갑옷.png", 
		"texture_dirty": "res://assets/relics/철제갑옷_흙.png"
	},
	{
		"id": "clay_pot",
		"name": "굽다리접시",
		"desc": "가야 특유의 고배형 토기. 높은 굽 위에 접시를 얹은 형태로 제사나 부장에 사용되었다.",
		"color": Color(0.6, 0.35, 0.2),
		"texture_clean": "res://assets/relics/굽다리접시.png", 
		"texture_dirty": "res://assets/relics/굽다리접시_흙.png"
	},
	{
		"id": "bronze_mirror",
		"name": "청동 거울",
		"desc": "신라~고려 시대 청동제 거울. 뒷면에 정교한 문양이 새겨져 있으며 의례용으로 추정된다.",
		"color": Color(0.3, 0.6, 0.5),
		"texture_clean": "res://assets/relics/청동거울.png", 
		"texture_dirty": "res://assets/relics/청동거울_흙.png"
	},
	{
		"id": "folk_painting",
		"name": "민화 — 호작도",
		"desc": "조선 후기 민화. 호랑이와 까치가 함께 그려진 도상으로, 액운을 쫓고 복을 부르는 의미를 담는다.",
		"color": Color(0.7, 0.4, 0.6),
		"texture_clean": "res://assets/relics/호작도.png", 
		"texture_dirty": "res://assets/relics/호작도_흙.png"
	},
]

func collect(relic_id: String) -> void:
	collected[relic_id] = true
	codex_updated.emit()

func _check_all_collected() -> bool:
	for r in RELICS:
		if not collected.get(r["id"], false):
			return false
	return true

func check_all_collected() -> bool:
	return _check_all_collected()

func is_collected(relic_id: String) -> bool:
	return collected.get(relic_id, false)

func get_relic(relic_id: String) -> Dictionary:
	for r in RELICS:
		if r["id"] == relic_id:
			return r
	return {}
