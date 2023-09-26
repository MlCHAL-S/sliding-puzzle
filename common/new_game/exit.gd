
extends Control

var timer = 0.0
var animating = false

var points_counter = 0
var points_threshold = 7
var points_timer = 0.0

func _ready():
	if is_visible():
		set_physics_process(true)

func animate():
	if(!animating):
		animating = true

func stop_animation():
	animating = false
	timer = 0.0
	get_node("Sprite").modulate.a = 1.0
	get_node("SpriteRev").modulate.a = 0.0

func is_animating():
	return animating

func _physics_process(delta):
	if(animating):
		timer += 4.0 * delta
		if timer<1:
			get_node("Sprite").modulate.a = 1.0 - min(1.0, max(0.0, sin(PI * timer)))
			get_node("SpriteRev").modulate.a = min(1.0, max(0.0, sin(PI * timer)))
		else:
			timer = 0.0
			animating = false
			get_parent().get_parent().exit()
	
	points_timer += delta
	if(timer > 1.0):
		points_counter = 0
		points_timer = 0

func _on_Exit_gui_input(event):
	if is_visible():
		if(!get_parent().get_parent().delayed()):
			animate()
			common.impulse()
