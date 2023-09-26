extends Node
var timer = 0.0
var delay = 1.0
var is_running = false
var test_count = 0
var screencapturecnt=1
func _ready():
	set_process_unhandled_key_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_physics_process(true)

# remote-key -> "Keyboard key code"
# power -> "XF86PowerOff"
# mode -> "Menu"
# rect -> "End"
# up ->   "Up"
# down ->  "Down"
# left ->  "Left"
# right -> "Right"
# ok ->   "Return"
# back -> "Escape"
# home ->  "Home"
# louder -> "XF86AudioRaiseVolume"
# quieter -> "XF86AudioLowerVolume"remote-key -> "Keyboard key code"


func _unhandled_key_input(key_event):
	common.impulse()
	if(key_event.scancode == KEY_ESCAPE and key_event.shift and key_event.pressed): #KILL
		get_tree().quit()

	if((key_event.scancode == KEY_M and key_event.shift or key_event.scancode == KEY_HOMEPAGE or key_event.scancode == KEY_HOME) and key_event.pressed): #MENU
		get_tree().get_current_scene().menu()
	if((key_event.scancode == KEY_U and key_event.shift or key_event.scancode == KEY_UP) and key_event.pressed): #UP
		get_tree().get_current_scene().up()
	if((key_event.scancode == KEY_D and key_event.shift or key_event.scancode == KEY_DOWN) and key_event.pressed): #DOWN
		get_tree().get_current_scene().down()
	if((key_event.scancode == KEY_L and key_event.shift or key_event.scancode == KEY_LEFT) and key_event.pressed): #LEFT
		get_tree().get_current_scene().left()
	if((key_event.scancode == KEY_R and key_event.shift or key_event.scancode == KEY_RIGHT) and key_event.pressed): #RIGHT
		get_tree().get_current_scene().right()
	if((key_event.scancode == KEY_3 and key_event.shift or key_event.scancode == KEY_ENTER) and key_event.pressed): #OK
		get_tree().get_current_scene().ok()
	if(((key_event.scancode == KEY_B and key_event.shift) or key_event.scancode == KEY_ESCAPE) and key_event.pressed): #BACK
		get_tree().get_current_scene().back()
	if((key_event.scancode == KEY_A and key_event.shift or key_event.scancode == KEY_END) and key_event.pressed): #ASPECT
		get_tree().get_current_scene().aspect()
	if((key_event.scancode == KEY_6 and key_event.shift or key_event.scancode == KEY_MENU) and key_event.pressed): #MODE
		get_tree().get_current_scene().mode()
	if(key_event.scancode == KEY_2 and key_event.shift and key_event.pressed): #POWER
		get_tree().get_current_scene().power()

	if((key_event.scancode == KEY_V and key_event.shift or key_event.scancode == KEY_VOLUMEUP) and key_event.pressed):
		get_tree().get_current_scene().volume_up()
	if((key_event.scancode == KEY_V and !key_event.shift or key_event.scancode == KEY_VOLUMEDOWN) and key_event.pressed):
		get_tree().get_current_scene().volume_down()
		
	if(key_event.scancode == KEY_F1 and key_event.pressed): #TESTER
		switch_tester()
	if(key_event.scancode == KEY_F2 and key_event.pressed): #REAL_LOOK_SIMULATION
		switch_real_look()
	if(key_event.scancode == KEY_F4 and key_event.pressed): #screenshot
		print("SCREENSHOT")
		var capture = get_viewport().get_texture().get_data()
		capture.flip_y()
		for i in range(3):
			yield(get_tree(),"idle_frame")
		#var texture  = ImageTexture.new()
		#texture.create_from_image(capture)
		capture.save_png("screencapture"+str(screencapturecnt)+".png")
		screencapturecnt+=1
		
	if(is_running and key_event.scancode != KEY_V):
		common.options["autoplay"] = 0

func switch_real_look():
	if(!get_tree().get_current_scene().has_node("RealLookSimulator")):
		if File.new().file_exists("res://common/RealLookSimulator/RealLookSimulator.tscn"):
			var rls = load("res://common/RealLookSimulator/RealLookSimulator.tscn").instance()
			if rls:
				get_tree().get_current_scene().add_child(rls)
				get_tree().get_current_scene().get_node("RealLookSimulator").activate()
	else:
		if(get_tree().get_current_scene().get_node("RealLookSimulator").is_visible()):
			get_tree().get_current_scene().get_node("RealLookSimulator").deactivate()
		else:
			get_tree().get_current_scene().get_node("RealLookSimulator").activate()


func switch_tester():
	if(!get_tree().get_current_scene().has_node("InputTester")):
		var input_tester = preload("res://common/input_tester/input_tester.tscn").instance()
		input_tester.activate()
		get_tree().get_current_scene().add_child(input_tester)
	else:
		if(get_tree().get_current_scene().get_node("InputTester").is_visible()):
			get_tree().get_current_scene().get_node("InputTester").deactivate()
		else:
			get_tree().get_current_scene().get_node("InputTester").activate()

func _physics_process(delta):
	if(!is_running):
		timer += delta
		if(timer > delay):
			is_running = true
			set_physics_process(false)

