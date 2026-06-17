extends Node2D

var _input_locked: bool = true

func _ready() -> void:
	$Player.add_to_group("player")
	await _show_chapter_title("Chapter 1", "발견")
	_input_locked = false

var _pending_chapter_clear := false
func _on_relic_collected() -> void:
	if GameData.is_collected("golden_crown"):
		_pending_chapter_clear = true

func _on_relic_popup_closed(rid: String) -> void:
	if rid == "golden_crown":
		SceneManager.go_to("res://scenes/Chapter2.tscn")

var _dialogue_skip := false
func _unhandled_input(event: InputEvent) -> void:
	if _input_locked:
		if event.is_action_pressed("shift_skip"):
			_dialogue_skip = true
		get_viewport().set_input_as_handled()

func _show_chapter_title(title: String, subtitle: String) -> void:
	var cl := CanvasLayer.new()
	cl.layer = 50
	add_child(cl)

	var container := Control.new()
	container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cl.add_child(container)

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.5)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(dim)

	var title_lbl := Label.new()
	title_lbl.text = title
	title_lbl.add_theme_font_size_override("font_size", 58)
	title_lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.3))
	title_lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.grow_horizontal = Control.GROW_DIRECTION_BOTH
	title_lbl.position.y -= 30
	container.add_child(title_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = subtitle
	sub_lbl.add_theme_font_size_override("font_size", 28)
	sub_lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	sub_lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.grow_horizontal = Control.GROW_DIRECTION_BOTH
	sub_lbl.position.y += 50
	container.add_child(sub_lbl)

	await get_tree().create_timer(1.2).timeout
	_input_locked = false
	var tw = create_tween()
	tw.tween_property(container, "modulate:a", 0.0, 0.5)
	await tw.finished
	cl.queue_free()
