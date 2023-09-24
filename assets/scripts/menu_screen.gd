extends Control

func _ready():
	$AnimationPlayer.play("menu_in")

func _on_Button_pressed():
	var nigger = load("res://assets/scripts/game_scene.gd")
	get_tree().change_scene_to(nigger)
