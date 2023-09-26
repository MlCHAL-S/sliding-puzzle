
extends Area2D

var points_counter = 0
var points_threshold = 7
var timer = 0

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	timer += delta
	if(timer > 1.0):
		points_counter = 0
		timer = 0

func _on_TutorialButton_input_event(viewport, event, shape_idx):
	points_counter += 1
	if(points_counter > points_threshold):
		points_counter = 0
		if(!common.options["remote_only"]):
			get_parent().tutorial()

