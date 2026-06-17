extends Control

const LINES: Array[String] = [
	"21XX년. 행소 유적 탐사 완료.",
	"",
	"총 %d점의 유물이 복원되었다.",
	"",
	"금동관, 철제 갑옷, 굽다리접시,\n청동 거울, 민화 — 호작도.",
	"",
	"이 유물들은 수천 년 전\n누군가의 삶과 함께했던 것들이다.",
	"",
	"복원된 유물 전부를\n행소박물관에 기증하기로 했다.",
	"",
	"언젠가 누군가가 이 유물들을 보며\n잊혀진 역사를 떠올리길 바란다.",
	"",
	"— 탐사 일지 끝 —",
]

var _line_index: int = 0
var _skip_requested: bool = false
var _all_shown: bool = false

@onready var _lbl: RichTextLabel = $Label
@onready var _skip: Button = $SkipBtn

func _ready() -> void:
	_lbl.text = ""
	_skip.pressed.connect(_on_skip)
	await _play_all_lines()
	_all_shown = true
	_show_end()

func _play_all_lines() -> void:
	for line in LINES:
		if _skip_requested:
			break
		var text_line: String = line
		if "%d" in text_line:
			text_line = text_line % GameData.collected.size()

		if text_line == "":
			_lbl.text += "\n"
			await get_tree().create_timer(0.3).timeout
			continue

		_lbl.text += "[center]"
		for ch in text_line:
			if _skip_requested:
				break
			_lbl.text += ch
			await get_tree().create_timer(0.045).timeout
		_lbl.text += "[/center]\n"

		if _skip_requested:
			break
		await get_tree().create_timer(0.6).timeout

	if _skip_requested:
		_show_full_text()

func _show_full_text() -> void:
	var full := ""
	for line in LINES:
		var text_line: String = line
		if "%d" in text_line:
			text_line = text_line % GameData.collected.size()
		if text_line == "":
			full += "\n"
		else:
			full += "[center]" + text_line + "[/center]\n"
	_lbl.text = full

func _show_end() -> void:
	_skip.text = "타이틀로 돌아가기"
	_skip.visible = true

func _on_skip() -> void:
	if _all_shown:
		SceneManager.go_to("res://scenes/MainMenu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if _all_shown:
		return
	if event is InputEventKey and event.pressed:
		_skip_requested = true
