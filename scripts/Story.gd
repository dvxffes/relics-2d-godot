extends Control

const LINES: Array[String] = [
	"21XX년.",
	"",
	"문명은 고도로 발전했지만,\n과거 역사 데이터 대부분이 소실된 시대.",
	"",
	"당신은 유물 복원사.",
	"",
	"전설적인 유적지 '행소 유적'을 찾아\n탐험을 떠납니다.",
	"",
	"가는 도중, 무언가 보입니다…",
]

@export var next_scene: String = "res://scenes/Chapter1.tscn"

@onready var _lbl: RichTextLabel = $Label

var _skip_all: bool = false
var _all_done: bool = false

func _ready() -> void:
	_lbl.bbcode_enabled = true
	_lbl.text = ""
	await _play_lines()
	_all_done = true

func _play_lines() -> void:
	var history := ""
	for line in LINES:
		if _skip_all:
			break

		if line == "":
			history += "\n"
			_lbl.text = history
			await get_tree().create_timer(0.3).timeout
			continue

		for i in range(line.length() + 1):
			if _skip_all:
				break
			_lbl.text = history + "[center]" + line.substr(0, i) + "[/center]"
			await get_tree().create_timer(0.045).timeout

		history += "[center]" + line + "[/center]\n"
		_lbl.text = history

		await get_tree().create_timer(0.6).timeout

	if _skip_all:
		var full_text := ""
		for line in LINES:
			if line == "":
				full_text += "\n"
			else:
				full_text += "[center]" + line + "[/center]\n"
		_lbl.text = full_text

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("shift_skip"):
		return

	if _all_done:
		SceneManager.go_to(next_scene)
	else:
		_skip_all = true
