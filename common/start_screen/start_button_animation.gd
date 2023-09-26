
extends Sprite
var timer = 0.0
var fade_in = true

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if(fade_in):
		if(timer <= 0.5):
			timer += delta
			modulate.a = min(timer*2.0, 1.0)
		else:
			timer = 0.0
			fade_in = false
