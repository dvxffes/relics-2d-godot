extends CanvasLayer

# ─────────────────────────────────────────
# RelicPopup.gd
# 유물 복원 미니게임
# 마우스로 드래그하면 더러운 레이어가 지워진다.
# 일정 % 이상 닦으면 획득 완료.
# ─────────────────────────────────────────

signal closed(relic_id: String)

@export var relic_id: String = "golden_crown"

const BRUSH_RADIUS: float = 28.0
const CLEAN_THRESHOLD: float = 0.72  # 72% 닦으면 완료

var _dirt_image: Image
var _dirt_texture: ImageTexture
var _total_pixels: int = 0
var _cleaned_pixels: int = 0
var _is_dragging: bool = false
var _complete: bool = false

const POP_W: float = 500.0
const POP_H: float = 420.0
const RELIC_SIZE: float = 220.0

@onready var _clean_sprite : Sprite2D       = $Panel/VBox/RelicArea/CleanSprite
@onready var _dirt_sprite : Sprite2D       = $Panel/VBox/RelicArea/DirtLayer
@onready var _complete_lbl: Label          = $Panel/VBox/CompleteLabel
@onready var _close_btn   : Button         = $Panel/VBox/CloseBtn

func _ready() -> void:
	layer = 20
	$Panel/VBox.alignment = BoxContainer.ALIGNMENT_CENTER
	$Panel/VBox.add_theme_constant_override("separation", 16)
	
	_close_btn.modulate.a = 0.0
	_close_btn.disabled = true
	_complete_lbl.modulate.a = 0.0

	var rdata: Dictionary = GameData.get_relic(relic_id)
	var dirty_path: String = rdata.get("texture_dirty", "")

	if dirty_path != "" and ResourceLoader.exists(dirty_path):
		var dirty_tex: Texture2D = load(dirty_path)
		_dirt_image = dirty_tex.get_image()
		_dirt_image.convert(Image.FORMAT_RGBA8)
		_dirt_image.resize(int(RELIC_SIZE), int(RELIC_SIZE))

	_dirt_texture = ImageTexture.create_from_image(_dirt_image)
	_dirt_sprite.texture = _dirt_texture

	var clean_path: String = rdata.get("texture_clean", "")
	if clean_path != "" and ResourceLoader.exists(clean_path):
		var tex: Texture2D = load(clean_path)
		_clean_sprite.texture = tex
		var tex_size: Vector2 = tex.get_size()
		var scale_factor: float = RELIC_SIZE / max(tex_size.x, tex_size.y)
		_clean_sprite.scale = Vector2(scale_factor, scale_factor)
	
	_total_pixels = 0
	for y in range(int(RELIC_SIZE)):
		for x in range(int(RELIC_SIZE)):
			if _dirt_image.get_pixel(x, y).a > 0.05:
				_total_pixels += 1
	_close_btn.pressed.connect(_on_close)

func _input(event: InputEvent) -> void:
	if _complete:
		return
	if event is InputEventMouseButton:
		_is_dragging = event.pressed
	if event is InputEventMouseMotion and _is_dragging:
		_brush(event.global_position)

func _brush(global_pos: Vector2) -> void:
	# Sprite2D 로컬 좌표로 변환
	var local_pos: Vector2 = _dirt_sprite.get_global_transform().affine_inverse() * global_pos
	# 스프라이트 원점은 중앙이므로 이미지 좌표로 변환
	var img_x: int = int(local_pos.x + RELIC_SIZE * 0.5)
	var img_y: int = int(local_pos.y + RELIC_SIZE * 0.5)

	var changed: bool = false
	var r: int = int(BRUSH_RADIUS)
	for dy in range(-r, r + 1):
		for dx in range(-r, r + 1):
			if dx * dx + dy * dy > r * r:
				continue
			var px: int = img_x + dx
			var py: int = img_y + dy
			if px < 0 or py < 0 or px >= int(RELIC_SIZE) or py >= int(RELIC_SIZE):
				continue
			var cur: Color = _dirt_image.get_pixel(px, py)
			if cur.a > 0.05:
				_dirt_image.set_pixel(px, py, Color(0, 0, 0, 0))
				_cleaned_pixels += 1
				changed = true

	if changed:
		_dirt_texture.update(_dirt_image)
		_check_complete()

func _check_complete() -> void:
	var ratio: float = float(_cleaned_pixels) / float(_total_pixels)
	if ratio >= CLEAN_THRESHOLD:
		_on_complete()

func _on_complete() -> void:
	if _complete:
		return
	_complete = true
	_dirt_image.fill(Color(0, 0, 0, 0))
	_dirt_texture.update(_dirt_image)

	GameData.collect(relic_id)

	var rdata: Dictionary = GameData.get_relic(relic_id)
	_complete_lbl.text = "✦  %s  획득!" % rdata.get("name", "유물")
	
	_complete_lbl.modulate.a = 1.0
	_close_btn.modulate.a = 1.0
	_close_btn.disabled = false

func _on_close() -> void:
	closed.emit(relic_id)
	queue_free()
