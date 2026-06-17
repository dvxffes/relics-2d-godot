extends Node2D

var _input_locked: bool = true

func _ready() -> void:
	$Player.add_to_group("player")
	await _show_intro_dialogue()
	await _show_chapter_title("Chapter 2", "깨달음")
	_input_locked = false

func _on_relic_popup_closed(rid: String) -> void:
	_dialogue_skip = false
	if GameData._check_all_collected():
		await _show_completion_message()
		SceneManager.go_to("res://scenes/Ending.tscn")

var _dialogue_skip := false
func _unhandled_input(event: InputEvent) -> void:
	if _input_locked:
		if event.is_action_pressed("shift_skip"):
			_dialogue_skip = true
		get_viewport().set_input_as_handled()

func _show_intro_dialogue() -> void:
	var lines: Array[String] = [
		"더 깊은 유적지.",
		"유물들이 하나둘 모이기 시작했다.",
		"단순한 물건이 아니다.\n오래전 사회가 잃어버렸던 역사의 흔적.",
		"아직 찾지 못한 것들이 더 있다.",
	]
	await _run_dialogue(lines)

func _run_dialogue(lines: Array[String]) -> void:
	var cl := CanvasLayer.new()
	cl.layer = 60
	add_child(cl)

	var container := Control.new()
	container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cl.add_child(container)

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.7)
	dim.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	dim.offset_top = -160
	dim.offset_bottom = 0
	container.add_child(dim)

	var lbl := Label.new()
	lbl.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	lbl.offset_top = -150
	lbl.offset_bottom = -20
	lbl.offset_left = 40
	lbl.offset_right = -40
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 28)
	lbl.add_theme_color_override("font_color", Color(0.92, 0.92, 0.92))
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	container.add_child(lbl)

	var skip_lbl := Label.new()
	skip_lbl.text = "[Shift] 스킵"
	skip_lbl.add_theme_font_size_override("font_size", 18)
	skip_lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	skip_lbl.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	skip_lbl.position += Vector2(-160, -40)
	container.add_child(skip_lbl)

	for line in lines:
		lbl.text = line
		container.modulate.a = 0.0
		var tw = create_tween()
		tw.tween_property(container, "modulate:a", 1.0, 0.4)
		await tw.finished

		var elapsed := 0.0
		while elapsed < 1.8 and not _dialogue_skip:
			if Input.is_action_just_pressed("shift_skip"):
				_dialogue_skip = true
			elapsed += get_process_delta_time()
			await get_tree().process_frame

		tw = create_tween()
		tw.tween_property(container, "modulate:a", 0.0, 0.3)
		await tw.finished
		
		if _dialogue_skip:
			break
	
	cl.queue_free()

func _show_completion_message() -> void:
	await _run_dialogue(["모든 유물을 복원했다."])

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
	title_lbl.position.y -= 50
	container.add_child(title_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = subtitle
	sub_lbl.add_theme_font_size_override("font_size", 28)
	sub_lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	sub_lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.grow_horizontal = Control.GROW_DIRECTION_BOTH
	sub_lbl.position.y += 30
	container.add_child(sub_lbl)

	await get_tree().create_timer(1.2).timeout
	var tw = create_tween()
	tw.tween_property(container, "modulate:a", 0.0, 0.5)
	await tw.finished
	cl.queue_free()
