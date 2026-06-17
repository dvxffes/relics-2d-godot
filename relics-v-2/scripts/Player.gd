extends CharacterBody2D

const SPEED: float = 180.0

var nearby_dig_site = null
var _last_dir: String = "down"  # 멈췄을 때 마지막 방향 유지

@onready var _anim: AnimatedSprite2D = $Sprite

func _ready() -> void:
	z_index = 3
	$Camera2D.limit_left = 0
	$Camera2D.limit_top = 0
	$Camera2D.limit_right = 1280
	$Camera2D.limit_bottom = 720

func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_action_pressed("move_right"): dir.x += 1
	if Input.is_action_pressed("move_left"):  dir.x -= 1
	if Input.is_action_pressed("move_down"):  dir.y += 1
	if Input.is_action_pressed("move_up"):    dir.y -= 1

	velocity = dir.normalized() * SPEED
	move_and_slide()
	_update_anim(dir)

func _update_anim(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		if _anim.is_playing():
			_anim.stop()
			_anim.frame = 1
		return

	# 대각선 입력 시 x 우선
	if dir.x > 0:
		_last_dir = "right"
	elif dir.x < 0:
		_last_dir = "left"
	elif dir.y < 0:
		_last_dir = "up"
	else:
		_last_dir = "down"

	var anim_name: String = "walk_" + _last_dir
	if _anim.animation != anim_name or not _anim.is_playing():
		_anim.play(anim_name)
