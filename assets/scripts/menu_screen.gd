extends Control

func _ready():
	$AnimationPlayer.play("menu_in")
	$Button2.connect("button_pressed", self, "on_pressed")
	#yield(get_tree(), "idle_frame")

func on_pressed():
	#	yield(get_tree().create_timer(1), "timeout")
	get_tree().get_current_scene().guardedDelayedChangeSceneWithPath("res://assets/scenes/game_scene.tscn")

