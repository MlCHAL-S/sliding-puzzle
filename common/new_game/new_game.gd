
extends Node2D

var timer = 0.0
var fade_in = true
var fade_out = null
var theexit = false
var pos
var asp
func _ready():
	
	position=common.npos(Vector2(0.5,0.5))
	set_physics_process(true)
	$C.modulate.a = 0.0
	$BackgroundFull.modulate.a = $C.modulate.a
	pause_mode=Node.PAUSE_MODE_PROCESS

	z_index=4096
	var vcorr=Vector2(-50,-50)
	if(common.options["remote_only"] or common.options["autoplay"] > 0):
		get_node("C/Exit").hide()
		get_node("C/Restart").show()
		get_node("C/Restart").set_position(Vector2(0,0)+vcorr)
	else:
		get_node("C/Restart").set_position(Vector2(200,0)+vcorr)
		get_node("C/Exit").set_position(Vector2(-200,0)+vcorr)
		get_node("C/Restart").show()
		get_node("C/Exit").show()
		
	$C.scale=Vector2(0.625,0.625)*get_node("/root/Main").get_fixed_scale()
	
func rotate_inside(angle):
	$C.set_rotation_degrees(angle)

func exit():
	theexit = true
	fade_out = 1.0
	
func restart():
	fade_out = 1.0

var bgcoeff=0.7
func _physics_process(delta):
	if(not fade_out and $C.modulate.a == 1.0):
		$BackgroundFull.modulate.a = $C.modulate.a*bgcoeff
		fade_in = false
	if(fade_in):
		$C.modulate.a = min(1.0, $C.modulate.a+delta*1.0)
		$BackgroundFull.modulate.a = $C.modulate.a*bgcoeff
	if(fade_out!=null):
		if(fade_out==0 and $C.modulate.a > fade_out):
			$C.modulate.a = max(fade_out, $C.modulate.a-delta*1)
			$BackgroundFull.modulate.a = $C.modulate.a*bgcoeff
		elif(fade_out==1.0 and $BackgroundFull.modulate.a < fade_out):
			$BackgroundFull.modulate.a = min(fade_out, $BackgroundFull.modulate.a+delta*1.0*0.5)
			$C.modulate.a = max(0, $C.modulate.a-delta*3.0*0.5)
		else:
			if(theexit):
				get_tree().get_current_scene().exit()
			else:
				get_tree().get_current_scene().restart()

func delayed():
	return fade_in

