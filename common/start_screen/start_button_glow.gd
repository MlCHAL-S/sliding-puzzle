
extends Sprite
var timer = 0.0
var period = 4.0
var fade_in = true
var custom_scale = 1.05
var opacity = 1.0

func _ready():
	set_physics_process(true)
	set_scale(Vector2(custom_scale, custom_scale))

func _physics_process(delta):
	if(!fade_in):
		timer += delta
		if(timer > period):
			timer -= period
		custom_scale = 1.03 + 0.02*cos(2.0*PI*timer/period)
		set_scale(Vector2(custom_scale, custom_scale))
		opacity = 0.9 + 0.1*cos(2.0*PI*timer/period)
		modulate.a = opacity
	else:
		if(timer <= 1.0):
			timer += delta
			modulate.a = min(timer, 1.0)
		else:
			timer = 0.0
			fade_in = false
