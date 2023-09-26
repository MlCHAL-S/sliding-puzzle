
extends Area2D

var timer = 0.0
var animating = false
var locked = false

var points_counter = 0
var points_threshold = 7
var points_timer = 0.0

var delayed = true
var delay_timer = 0.0
var delay = 1.0

func _ready():
	set_physics_process(true)

func animate():
	if(!animating and !locked):
		animating = true
		if(get_name() == "1"):
			get_parent().get_node("2").locked = true
		elif(get_name() == "2"):
			get_parent().get_node("1").locked = true

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
		get_node("Sprite").modulate.a = 1.0 - min(1.0, max(0.0, sin(PI * timer)))
		get_node("SpriteRev").modulate.a = min(1.0, max(0.0, sin(PI * timer)))
		if(timer >= 1.0):
			timer = 0.0
			animating = false
			get_parent().set_difficulty(int(get_name()))
			get_parent().hide()
	if(!locked):
		points_timer += delta
		if(timer > 1.0):
			points_counter = 0
			points_timer = 0
	
	if(delayed):
		delay_timer += delta
		if(delay_timer > delay):
			delay_timer = 0.0
			delayed = false

func _on_1_input_event(viewport, event, shape_idx):
	if(!locked and !delayed):
		points_counter += 1
		if(points_counter > points_threshold):
			points_counter = 0
			animate()
			common.impulse()

func _on_2_input_event(viewport, event, shape_idx):
	if(!locked and !delayed):
		points_counter += 1
		if(points_counter > points_threshold):
			points_counter = 0
			animate()
			common.impulse()
