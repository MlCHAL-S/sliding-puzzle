
extends Node2D

var playing = false
var delayed = true
var timer = 0.0

func _ready():
	set_physics_process(true)

func play_tutorial():
	if(!playing):
		playing = true
		delayed = true
		get_node("VideoPlayer").play()

func _physics_process(delta):
	if(playing):
		if(delayed):
			timer += delta
			if(timer > 1.0):
				timer = 0.0
				delayed = false
				show()
		elif(!get_node("VideoPlayer").is_playing()):
			playing = false
			hide()

func is_playing():
	return playing
