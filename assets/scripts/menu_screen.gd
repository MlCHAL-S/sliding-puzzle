extends Control

func _ready():
	$AnimationPlayer.play("menu_in")
	$Button2.connect("button_pressed", self, "on_pressed")
	$Button2.rect_min_size.x = 50
	$Button2.rect_min_size.y = 20
	$Button2/Label.text = "Play"
	$Button2/TextureProgress.set_fill_mode(0)
	#yield(get_tree(), "idle_frame")

func on_pressed():
	#	yield(get_tree().create_timer(1), "timeout")
	get_tree().current_scene.changeSceneWithFilePath("res://assets/scenes/game_scene.tscn")

