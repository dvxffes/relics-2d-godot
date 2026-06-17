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

@onready var _lbl: RichTextLabel = $Label
@onready var _skip: Button = $SkipBtn

func _ready() -> void:
	_lbl.text = ""
	_lbl.add_theme_constant_override("alignment", HORIZONTAL_ALIGNMENT_CENTER)
	_skip.pressed.connect(_on_skip)
	_show_next_line()

func _show_next_line() -> void:
	if _line_index >= LINES.size():
		_show_end()
		return

	var line: String = LINES[_line_index]
	# 유물 수 자동 삽입
	if "%d" in line:
		line = line % GameData.collected.size()

	_line_index += 1

	if line == "":
		_lbl.text += "\n"
		await get_tree().create_timer(0.3).timeout
	else:
		_lbl.text += "[center]"
		for ch in line:
			_lbl.text += ch
			await get_tree().create_timer(0.045).timeout
		_lbl.text += "[/center]\n"
		await get_tree().create_timer(0.6).timeout
	_show_next_line()

func _show_end() -> void:
	_skip.text = "타이틀로 돌아가기"
	_skip.visible = true

func _on_skip() -> void:
	SceneManager.go_to("res://scenes/MainMenu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if _line_index < LINES.size():
			_lbl.text = ""
			for l in LINES:
				var text_line: String = l
				if "%d" in text_line:
					text_line = text_line % GameData.collected.size()
				if text_line == "":
					_lbl.text += "\n"
				else:
					_lbl.text += "[center]" + text_line + "[/center]\n"
			_line_index = LINES.size()
			_show_end()
