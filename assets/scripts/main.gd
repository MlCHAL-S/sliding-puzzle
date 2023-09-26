extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
#	get_tree().get_current_scene().guardedDelayedChangeSceneWithPath("res://assets/scenes/menu_screen.tscn")
	#yield(get_tree().create_timer(1), "timeout")
	get_tree().get_current_scene().guardedDelayedChangeSceneWithPath("res://assets/scenes/menu_screen.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
