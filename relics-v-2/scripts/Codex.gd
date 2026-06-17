extends CanvasLayer

# ─────────────────────────────────────────
# Codex.gd  — 도감 UI
# E키로 열고 닫기
# 수집한 유물: 아이콘 + 이름
# 미수집: ??? 표시
# 클릭하면 우측에 상세 설명
# ─────────────────────────────────────────

var _selected_id: String = ""

@onready var _panel      : Control  = $Panel
@onready var _grid       : GridContainer = $Panel/HSplit/Left/ScrollContainer/Grid
@onready var _name_lbl   : Label    = $Panel/HSplit/Right/NameLabel
@onready var _desc_lbl   : RichTextLabel = $Panel/HSplit/Right/DescLabel
@onready var _icon_big   : Sprite2D = $Panel/HSplit/Right/IconBig

func _ready() -> void:
	layer = 15
	_panel.visible = false
	GameData.codex_updated.connect(_refresh)
	_refresh()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_codex"):
		_panel.visible = not _panel.visible
		get_viewport().set_input_as_handled()

func _refresh() -> void:
	for c in _grid.get_children():
		c.queue_free()

	for relic in GameData.RELICS:
		var rid: String = relic["id"]
		var got: bool = GameData.is_collected(rid)

		var btn := Button.new()
		btn.custom_minimum_size = Vector2(90, 90)
		btn.tooltip_text = relic["name"] if got else "???"

		if got:
			var clean_path: String = relic.get("texture_clean", "")
			if clean_path != "" and ResourceLoader.exists(clean_path):
				var tex_rect := TextureRect.new()
				tex_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
				tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
				tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				tex_rect.texture = load(clean_path)
				tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
				btn.add_child(tex_rect)
			else:
				var color_rect := ColorRect.new()
				color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
				color_rect.color = relic["color"]
				color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
				btn.add_child(color_rect)
		else:
			var color_rect := ColorRect.new()
			color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			color_rect.color = Color(0.2, 0.2, 0.2)
			color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			btn.add_child(color_rect)

			var lbl := Label.new()
			lbl.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			lbl.text = "???"
			lbl.add_theme_font_size_override("font_size", 13)
			lbl.add_theme_color_override("font_color", Color.WHITE)
			lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			btn.add_child(lbl)

		# 미획득 어둡게
		if not got:
			btn.modulate = Color(0.5, 0.5, 0.5, 0.7)

		btn.pressed.connect(func(): _on_select(rid))
		_grid.add_child(btn)

func _on_select(rid: String) -> void:
	_selected_id = rid
	var relic: Dictionary = GameData.get_relic(rid)
	var got: bool = GameData.is_collected(rid)
	
	for c in _icon_big.get_parent().get_children():
		if c.name == "IconBigTexture":
			c.queue_free()
	
	if got:
		_name_lbl.text = relic["name"]
		_desc_lbl.text = relic["desc"]

		var clean_path: String = relic.get("texture_clean", "")
		if clean_path != "" and ResourceLoader.exists(clean_path):
			_icon_big.visible = false
			var tex_rect := TextureRect.new()
			tex_rect.name = "IconBigTexture"
			tex_rect.custom_minimum_size = Vector2(0, 120)
			tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tex_rect.texture = load(clean_path)
			_icon_big.get_parent().add_child(tex_rect)
			_icon_big.get_parent().move_child(tex_rect, _icon_big.get_index())
		else:
			_icon_big.visible = true
			_icon_big.color = relic["color"]
	else:
		_name_lbl.text = "???"
		_desc_lbl.text = "아직 복원되지 않은 유물입니다."
		_icon_big.visible = true
		_icon_big.color = Color(0.2, 0.2, 0.2)
