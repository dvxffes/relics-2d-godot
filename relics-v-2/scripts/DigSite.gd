extends Node2D

# ─────────────────────────────────────────
# DigSite.gd
# 발굴 가능 칸. 플레이어가 범위 안에서
# 상호작용키를 3번 누르면 유물 복원 팝업을 연다.
# ─────────────────────────────────────────

@export var relic_id: String = "golden_crown"
@export var already_dug: bool = false

const MAX_DIGS: int = 3

var _dig_count: int = 0
var _player_inside: bool = false

@onready var _label: Label = $HintLabel
@onready var _area: Area2D = $Area2D
@onready var _progress: Label = $ProgressLabel

func _ready() -> void:
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)
	_update_ui()
	if already_dug:
		_set_dug_state()

func _unhandled_input(event: InputEvent) -> void:
	if already_dug or not _player_inside:
		return
	if event.is_action_pressed("interact"):
		_do_dig()

func _do_dig() -> void:
	_dig_count += 1
	_update_ui()

	if _dig_count >= MAX_DIGS:
		_open_relic_popup()

func _open_relic_popup() -> void:
	already_dug = true
	_set_dug_state()
	var popup_scene = load("res://scenes/RelicPopup.tscn")
	var popup = popup_scene.instantiate()
	popup.relic_id = relic_id
	popup.closed.connect(get_tree().current_scene._on_relic_popup_closed)
	get_tree().root.get_child(-1).add_child(popup)

func _set_dug_state() -> void:
	$Base.texture = preload("res://assets/ground_dug.png")
	_label.visible = false
	_progress.visible = false

func _update_ui() -> void:
	if already_dug:
		return
	_progress.text = "[ %d / %d ]" % [_dig_count, MAX_DIGS]

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_inside = true
		body.nearby_dig_site = self
		_label.visible = not already_dug

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_inside = false
		body.nearby_dig_site = null
		_label.visible = false
