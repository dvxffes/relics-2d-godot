extends CanvasLayer

var _fade: ColorRect
var _tween: Tween

func _ready() -> void:
	layer = 100
	_fade = ColorRect.new()
	_fade.color = Color(0, 0, 0, 0)
	_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_fade)

func go_to(scene_path: String, duration: float = 0.7) -> void:
	_fade.mouse_filter = Control.MOUSE_FILTER_STOP
	await _fade_to(1.0, duration * 0.5)
	get_tree().change_scene_to_file(scene_path)
	await _fade_to(0.0, duration * 0.5)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _fade_to(alpha: float, dur: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_fade, "color:a", alpha, dur)
	await _tween.finished

func go_to_with_title(scene_path: String, title: String, subtitle: String = "") -> void:
	_fade.mouse_filter = Control.MOUSE_FILTER_STOP
	await _fade_to(1.0, 0.5)
	get_tree().change_scene_to_file(scene_path)
	
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.5)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	
	var title_lbl := Label.new()
	title_lbl.text = title
	title_lbl.add_theme_font_size_override("font_size", 58)
	title_lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.3))
	title_lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.grow_horizontal = Control.GROW_DIRECTION_BOTH
	title_lbl.position.y -= 50
	add_child(title_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = subtitle
	sub_lbl.add_theme_font_size_override("font_size", 28)
	sub_lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	sub_lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.grow_horizontal = Control.GROW_DIRECTION_BOTH
	sub_lbl.position.y += 30
	add_child(sub_lbl)
	
	await _fade_to(0.0, 0.5)
	await get_tree().create_timer(2.0).timeout
	await _fade_to(1.0, 0.5)
	title_lbl.queue_free()
	sub_lbl.queue_free()
	dim.queue_free()
	await _fade_to(0.0, 0.5)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
