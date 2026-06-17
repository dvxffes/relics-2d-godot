extends CanvasLayer

# ─────────────────────────────────────────
# Tutorial.gd
# 순차적 튜토리얼 스텝
# ─────────────────────────────────────────

const STEPS: Array[Dictionary] = [
	{
		"text": "WASD 키로 이동할 수 있습니다.",
		"trigger": "move"
	},
	{
		"text": "반짝이는 칸이 발굴 가능한 지점입니다.\n가까이 다가가 보세요.",
		"trigger": "approach_dig"
	},
	{
		"text": "Enter 또는 Space를 3번 눌러 발굴하세요!",
		"trigger": "dig_complete"
	},
	{
		"text": "마우스로 드래그해서 유물을 닦아내세요.",
		"trigger": "clean_complete"
	},
	{
		"text": "E 키로 도감을 열어 획득한 유물을 확인하세요.",
		"trigger": "codex_open"
	},
]

var _step: int = 0
var _done: bool = false

@onready var _panel : PanelContainer = $Panel
@onready var _lbl   : RichTextLabel  = $Panel/Label

func _ready() -> void:
	layer = 12
	GameData.codex_updated.connect(_on_relic_collected)

	_panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	_panel.offset_right = 500
	_panel.offset_bottom = 110
	_panel.offset_left = 16
	_panel.offset_top = 16

	_lbl.add_theme_font_size_override("font_size", 20)
	_show_step()

func _show_step() -> void:
	if _step >= STEPS.size():
		_finish()
		return
	_lbl.text = STEPS[_step]["text"]

func _unhandled_input(event: InputEvent) -> void:
	if _done:
		return
	var trigger: String = STEPS[_step]["trigger"] if _step < STEPS.size() else ""

	match trigger:
		"move":
			if event is InputEventKey and (
				event.is_action_pressed("move_up") or event.is_action_pressed("move_down") or
				event.is_action_pressed("move_left") or event.is_action_pressed("move_right")):
				_next()
		"codex_open":
			if event.is_action_pressed("open_codex"):
				_next()

func advance_trigger(trigger_name: String) -> void:
	if _done:
		return
	if _step < STEPS.size() and STEPS[_step]["trigger"] == trigger_name:
		_next()

func _on_relic_collected() -> void:
	advance_trigger("clean_complete")

func _next() -> void:
	_step += 1
	_show_step()

func _finish() -> void:
	_done = true
	_panel.visible = false
