extends Control

func _ready() -> void:
	$VBox/BtnStart.pressed.connect(func(): SceneManager.go_to("res://scenes/Story.tscn"))
	$VBox/BtnQuit.pressed.connect(func(): get_tree().quit())
	$VBox/Title.add_theme_font_size_override("font_size", 72)
	$VBox/Title.add_theme_color_override("font_color", Color(0.9, 0.78, 0.2))
	$VBox/Sub.add_theme_font_size_override("font_size", 20)
	$VBox/Sub.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	$VBox/BtnStart.add_theme_font_size_override("font_size", 20)
	$VBox/BtnQuit.add_theme_font_size_override("font_size", 20)
	modulate.a = 0.0
	create_tween().tween_property(self, "modulate:a", 1.0, 1.0)
