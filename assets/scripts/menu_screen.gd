extends Control

func _ready():
	$AnimationPlayer.play("menu_in")

func _on_Button_pressed():
	get_tree().change_scene("res://assets/scenes/game_scene.tscn")
