extends Node

var motion_input = VFMotionInput.new()

func _physics_process(delta):
	motion_input.update()

func _ready():
	set_pause_mode(PAUSE_MODE_PROCESS)
