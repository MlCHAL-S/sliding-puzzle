extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func activate():
	get_node("TextureRect").set_physics_process(true)
	get_node("TextureRect").set_process_unhandled_key_input(true)
	show()

func deactivate():
	get_node("TextureRect").set_physics_process(false)
	get_node("TextureRect").set_process_unhandled_key_input(false)
	hide()
