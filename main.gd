extends Node2D

# FIRST common is loaded and inited, so every init goes there into _ready
# NEXT main _ready is invoked, when all inited - the game is started

export (PackedScene) var gameMainScene
var currentGameSceneNode
var sceneWaiting2Load

var input_counter = 0
var input_timer = 0.0
var start_time = 0
var do_diagnose_log=false
var log_data=""
var log_count=0
var mutex
var window_size
var viewport_size
var current_viewport_size
var camera
var pause_screen
var pause_processing=true
var border = null

# KacperP mod:
# when true, border appears when:
# resize method=expand
# vertical resolution is bigger than set in game

var use_border=false

signal fade_finished
func _ready():
	print("MAIN init START")

	if common.options["testmode"]:
		$FadeMask.hide()
	mutex=Mutex.new()
	start_time=OS.get_unix_time()
	window_size=common.get_window_size()
	viewport_size=common.base_viewport_size
	current_viewport_size=common.true_base_viewport_size
	if window_size.x>2000: window_size/=2
	print("WINDOW SIZE:"+str(window_size))
	print("VIEWPORT SIZE:"+str(common.base_viewport_size))
	
	common.LoadLocalGameSettings()
	
	init_zoom_camera()
	
	get_viewport().get_texture().flags |= Texture.FLAG_FILTER

	if has_node("SceneTransition"):
		$SceneTransition.centered = true
		$SceneTransition.pause_mode = Node.PAUSE_MODE_PROCESS

	init_pause()

	init_diagnose_log()

	init_game_parameters()

	#------------------
	init_the_game()
	#------------------
	
	set_process_input(true)

	init_bg_tasks()

	init_cropmask()

	if use_border:
		init_border()

	common.call_deferred("set_window_size",common.getZoom())
	call_deferred("init_addons")
	call_deferred("init_network_client")
	
	if not common.options["testmode"]:
		fade()
	
	print("MAIN init END")

func init_the_game():
	if(common.current_scene == common.GAMESCREEN or common.options["no_startscreen"]):
		var main
		if(gameMainScene != null):
			main = gameMainScene.instance()
		else:
			main = load("res://assets/scenes/main.tscn").instance()
		add_child(main)
		currentGameSceneNode = weakref(main)
		common.current_scene = common.GAMESCREEN
	else:
		if(!has_node("StartScreen")):
			var start_screen = preload("res://common/start_screen/start_screen.tscn").instance()
			add_child(start_screen)

func init_network_client():
	if ! get_node("/root").has_node("NetworkClient"):
		if(common.options.has("network_client_active") and common.options["network_client_active"]):
			get_node("/root").add_child(preload("res://common/network_connection/network_client.tscn").instance())

func init_diagnose_log():
	var interval=common.GetGameParameter("diagnose_map_interval","0")
	if interval!="0":
		if common.writeFile("/dev/shm/mapwriteeveryseconds",interval)!=0:
			print("Cannot open /dev/shm/mapwriteeveryseconds for writing")
	if common.GetGameParameter("do_diagnose_log",false)==true:
		do_diagnose_log=true

func init_pause():
	pause_screen = preload("res://common/pause_screen/PauseScreen.tscn").instance()
	add_child(pause_screen)


func init_bg_tasks():
	if not has_node("TimerBGTasks"):
		var tm=Timer.new()
		var s=GDScript.new()
		s.set_source_code("func _on_Timer_timeout(): if get_parent().has_method(\"processbgtasks\"): get_parent().processbgtasks()")
		tm.set_script(s)
		tm.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
		tm.set_one_shot(false)
		tm.set_name("TimerBGTasks")
		tm.set_wait_time(1.123)
		tm.connect("timeout",self,"processbgtasks")
		add_child(tm)
		tm.start()

# ADD CROPMASK, needed in zoommed view
# to cover all objects around and outsize game playfield
func init_cropmask():
	var cropmask=Polygon2D.new()
	var polygon=PoolVector2Array()
	polygon.resize(4)
	polygon[0]=Vector2(0,0)
	polygon[1]=Vector2(common.base_viewport_size.x,0)
	polygon[2]=common.base_viewport_size
	polygon[3]=Vector2(0,common.base_viewport_size.y)
	
	cropmask.set_polygon(polygon)
	cropmask.set_color(Color(0,0,0,1))
	cropmask.set_invert(true)
	cropmask.invert_border=1000
	cropmask.z_index=4096
	cropmask.set_name("CropMask")
	add_child(cropmask)

# needed for zoom to work
func init_zoom_camera():
	camera = Camera2D.new()
	camera.name = "camera"
	add_child(camera)
	camera.current = true
	camera.position = common.base_viewport_size / 2.0
	camera.drag_margin_h_enabled = false
	camera.drag_margin_v_enabled = false

# adds fading blurry borders when stretch mode set to expand
# and game is 16:10 when run on 4:5 monitor

func init_border():
	border = load("res://common/border_color/border.tscn").instance()
	add_child(border)
	border.rect_min_size = viewport_size
	VisualServer.canvas_item_set_z_index(border.get_canvas_item(), 4096)

func init_game_parameters():
	if File.new().file_exists("res://local/game_parameters/GameParameters.tscn") or  File.new().file_exists("res://local/game_parameters/GameParameters.tscn.converted.scn"):
		var additional_parameters=load("res://local/game_parameters/GameParameters.tscn")
		if additional_parameters:
			additional_parameters=additional_parameters.instance()
			additional_parameters.register_parameters()
			# load local section to update default values
			common.LoadMainGameConfig("Game_Local")
		else:
			print("Skipping local game parameters, local/game_parameters/GameParameters.tscn not found")


func init_addons():
	if ! get_node("/root").has_node("VFMotionInput"):
		if(type_exists("VFMotionInput")):
			var vfmi = load("res://common/motion_input/vf_motion_input.tscn").instance()
			get_node("/root").add_child(vfmi)
		
	if ! get_node("/root").has_node("Controls"):
		var controls = load("res://common/controls/controls.tscn").instance()
		get_node("/root").add_child(controls)
	
	if ! get_node("/root").has_node("GameVersion"):
		if File.new().file_exists("res://common/game_version/game_version.tscn"):
			var game_version = load("res://common/game_version/game_version.tscn").instance()
			if game_version!=null:
				get_node("/root").add_child(game_version)
			else:
				print("VERSION FILE res://common/game_version/game_version.tscn cannot load")
		else:
			print("VERSION FILE res://common/game_version/game_version.tscn does not exist")

	if ! get_node("/root").has_node("FileOps"):
		if(type_exists("VFFileOps")):
			var vffo = load("res://common/file_ops/file_ops.tscn").instance()
			get_node("/root").add_child(vffo)
			common.fileops = vffo.fileops
			common.lockscreen_increment_timer = common.fileops.getNotUsed()

var game_rotation=0

func set_game_orientation(dir):
	var rots={"bottom":0,"left":90,"right":270,"up":180}
	if dir in rots:
		game_rotation=rots[dir]
	else:
		print("Unknown orientation "+str(dir)+", set to 0")
		game_rotation=0;

func set_pause_version(v):
	pause_screen.set_pause_version(v)

func get_game_rotation():
	return game_rotation
	
func get_display_scale():

	return Vector2(1,common.get_aspect_ratio()/1.6)*Vector2(0.625,0.75)

func get_fixed_scale():
	var s=viewport_size.aspect()/window_size.aspect()
	var sc=Vector2(1,1)
	if ProjectSettings.get_setting("display/window/stretch/aspect")=="ignore":
		sc=Vector2(s,1)
	sc*=common.base_viewport_size.y/common.window_size.y
	return sc

func prescale_tree(node=null,tscale=null):
	
	if tscale==null:
		tscale=get_display_scale()
		
	print("Prescale ratio: "+str(tscale))
	if node==null:
		prescale_tree(get_node("/root"),tscale)
		return
	
	if node.has_method("do_not_prescale"):
		if node.do_not_prescale():
			return
	
	if node.get_child_count()<=1:
		print(node.get_class())
		if node.get_class() in ["Sprite","AnimatedSprite"]:
			print("Scale of "+node.get_name()+" set to "+str(tscale))
			node.set_scale(tscale)
		return
		
	for n in node.get_children():
		prescale_tree(n,tscale)
		
func fade():
	$FadeMask.z_index=4096
	$FadeMask.modulate.a=0
	$FadeMask.show()
	$FadeMask.raise()

	if use_border:
		border.raise()

	for i in range(21):
		$FadeMask.modulate.a=1-i/20.0
		yield(get_tree(),"idle_frame")
		
func fadeout():
	$FadeMask.z_index=4096
	$FadeMask.raise()

	if use_border:
		border.raise()

	for i in range(21):
		$FadeMask.modulate.a=i/20.0
		yield(get_tree(),"idle_frame")
	emit_signal("fade_finished")

func _input(event):
	if input_counter==0:
		if(event is InputEventScreenTouch or event is InputEventMouseMotion):
			input_counter=1
	if do_diagnose_log:
		if(event is InputEventMouseMotion):
			store_log(["MoveTo",event.global_x,event.global_y])
		if(event is InputEventScreenTouch):
			store_log(["MoveTo",event.position.x,event.position.y])
	if common.options.is_screensaver:
		ScreensaverDissapear()

func ScreensaverDissapear():
	if($FadeMask.modulate.a > 0):
		return
	else:
		for i in range(140):
			$FadeMask.modulate.a = i*i*i/4500000.0
			yield(get_tree(), "idle_frame")
		$FadeMask.modulate.a = 1
		get_tree().quit()

func store_log_array(starr):
	var millis=OS.get_ticks_msec()
	var tstamp= str(millis/1000+start_time)+"."+str(millis%1000).pad_zeros(3)+","
	for st in starr:
		log_count+=1
		if log_count>20: break;

		if typeof(st)==TYPE_STRING:
			#mutex.lock()
			log_data+=str(millis/1000+start_time)+"."+str(millis%1000).pad_zeros(3)+","+st+"\n"
			#mutex.unlock()
		else:
			if st[1]>=0 and st[1]<800 and st[2]>=0 and st[2]<600:
				st[1]/=800.0
				st[2]/=600.0
				var s=str(st)
				#mutex.lock()
				log_data+=tstamp+s.substr(1,s.length()-2).replace(" ","")+"\n"
				#mutex.unlock()
	
func save_log():
	if not do_diagnose_log: return

	if log_data=="": return
	
	var fdir=Directory.new()

	var filename=common.GetGameParameter("diagnose_log_filename","/dev/shm/diagnose_%s.log")
	filename = filename % str(start_time)
	if not fdir.dir_exists(filename.get_base_dir()):
		fdir.make_dir_recursive(filename.get_base_dir())
		if not fdir.dir_exists(filename.get_base_dir()):
			print("Cannot make dir "+filename.get_base_dir())
			return

	var flog=File.new()
	if (flog.file_exists(filename)):
		flog.open(filename,flog.READ_WRITE)
	else:
		flog.open(filename,flog.WRITE)
	if (flog.get_error()==0):
		flog.seek_end()

		#mutex.lock()
		flog.store_string(log_data)
		log_data=""
		log_count=0
		#mutex.unlock()
		flog.close()

func store_log(st):
	store_log_array([st])

# invoked every second or two by Timer node, if exists
func processbgtasks(): 
	if input_counter>0:
		input_counter = 0
		common.impulse()
	if do_diagnose_log:
		save_log()

var pause_obj_arr={}
func isPaused(id=null):
	if id:
		if pause_obj_arr.has(id):
			return pause_obj_arr[id]
		return false
	return get_tree().paused
	
# Pause semantics:
#
# Pause can be off by presing any key but not Volume keys
# When pressed Home key, the game exits.
# 
# TurnPause switches pause to oposite state
func setPause(p=true,id="null", disable_gui=false):
	pause_obj_arr[id]=p
		
	var cond=false
	for i in pause_obj_arr:
		cond = cond or pause_obj_arr[i]
		
	get_tree().paused=cond
	get_tree().get_root().gui_disable_input = disable_gui

func enablePauseProcessing(b=true):
	pause_processing=b

# TurnPause:
# pause flip flop
func TurnPause():
	var n=get_node("PauseScreen");
	if !n: return
	var paused=isPaused("Pause")
	var nanim=n.get_node("AnimationPlayer")
	
	if(!paused):
		n.rotate_inside(get_game_rotation())
		n.show()
		nanim.play("Appear")
	elif(paused):
		nanim.play_backwards("Appear")
		yield(nanim,"animation_finished")
		n.hide()
	setPause(!paused,"Pause")

func ok():
	if isPaused("Pause"):
		TurnPause()
		return
	if(common.current_scene == common.STARTSCREEN):
		get_node("StartScreen").start()
	elif(common.current_scene == common.GAMESCREEN):
		if (currentGameSceneNode.get_ref()):
			if(currentGameSceneNode.get_ref().has_method("ok")):
				currentGameSceneNode.get_ref().ok()

func right():
	if isPaused("Pause"):
		TurnPause()
		return
	if(common.current_scene == common.STARTSCREEN):
		get_node("StartScreen").tutorial()
	elif(common.current_scene == common.GAMESCREEN):
		if has_node("/root/Main/NewGame"):
			get_node("/root/Main/NewGame").restart()
		elif(!common.has_difficulty):
			if (currentGameSceneNode.get_ref()):
				if(currentGameSceneNode.get_ref().has_method("right")):
					currentGameSceneNode.get_ref().right()
		elif(common.has_difficulty):
			if (currentGameSceneNode.get_ref()):
				currentGameSceneNode.get_ref().get_node("Difficulty").right()

func left():
	if isPaused("Pause"):
		TurnPause()
		return
	if(common.current_scene == common.GAMESCREEN):
		if has_node("/root/Main/NewGame"):
			get_node("/root/Main/NewGame").exit()
		if (currentGameSceneNode.get_ref()):
			if(!common.has_difficulty):
				if (currentGameSceneNode.get_ref()):
					if(currentGameSceneNode.get_ref().has_method("left")):
						currentGameSceneNode.get_ref().left()
			elif(common.has_difficulty):
				if (currentGameSceneNode.get_ref()):
					currentGameSceneNode.get_ref().get_node("Difficulty").left()
		
func back():
	if common.options.is_screensaver:
		return
	elif(isPaused("Pause")):
		TurnPause()
		return
	if(common.current_scene == common.STARTSCREEN):
		fadeout()
		yield(self,"fade_finished")
		get_tree().quit()
	elif(common.current_scene == common.GAMESCREEN):
		if (currentGameSceneNode.get_ref()):
			if(currentGameSceneNode.get_ref().has_method("back")):
				if(!currentGameSceneNode.get_ref().back()):
					back_to_start_screen()
			else:
				back_to_start_screen()
		else:
			back_to_start_screen()

func back_to_start_screen():
	if(!common.options["no_startscreen"]):
		common.current_scene = common.STARTSCREEN
		get_tree().reload_current_scene()
	else:
		fadeout()
		yield(self,"fade_finished")

		get_tree().quit()

func up():
	if isPaused("Pause"):
		TurnPause()
		return
	if(common.current_scene == common.GAMESCREEN):
		if (currentGameSceneNode.get_ref()):
			if(currentGameSceneNode.get_ref().has_method("up")):
				currentGameSceneNode.get_ref().up()

func down():
	if(!common.options.is_screensaver and pause_processing and (!has_node("/root/Main/NewGame"))):
		TurnPause()
		return
	if(common.current_scene == common.GAMESCREEN):
		if (currentGameSceneNode.get_ref()):
			if(currentGameSceneNode.get_ref().has_method("down")):
				currentGameSceneNode.get_ref().down()

func power():
	if(isPaused("Pause")):
		return
	if(common.current_scene == common.GAMESCREEN):
		if (currentGameSceneNode.get_ref()):
			if(currentGameSceneNode.get_ref().has_method("power")):
				currentGameSceneNode.get_ref().power()

func menu():
	if isPaused("Pause"):
		back_to_start_screen()
		return
	if(common.current_scene == common.GAMESCREEN):
		if (currentGameSceneNode.get_ref()):
			if(currentGameSceneNode.get_ref().has_method("menu")):
				currentGameSceneNode.get_ref().menu()
			else:
				back_to_start_screen()
		else:
			back_to_start_screen()

func aspect():
	if(common.options.is_screensaver):
		return
	if(common.current_scene == common.GAMESCREEN):
		if common.options["teachers_screen_on_aspect_key"]:
			if(get_tree().root.has_node("/root/NetworkClient")):
				get_tree().root.get_node("NetworkClient").SendCommand("aspect")
		elif common.options["zoom_on_aspect_key"]==true:
			common.aspect()
		if common.options["custom_aspect_key"]==true:
			if (currentGameSceneNode.get_ref()):
				if(currentGameSceneNode.get_ref().has_method("aspect")):
					currentGameSceneNode.get_ref().aspect()

func mode():
	if isPaused("Pause"):
		TurnPause()
		return
	elif(common.current_scene == common.GAMESCREEN):
		if (currentGameSceneNode.get_ref()):
			if(currentGameSceneNode.get_ref().has_method("mode")):
				currentGameSceneNode.get_ref().mode()

func start():
	if(common.current_scene == common.STARTSCREEN and typeof(currentGameSceneNode) == 0):
		var main
		if(gameMainScene != null):
			main = gameMainScene.instance()
		else:
			main = load("res://assets/scenes/main.tscn").instance()
		get_tree().get_current_scene().add_child(main)
		currentGameSceneNode = weakref(main)
		common.current_scene = common.GAMESCREEN

func restart():
	common.current_scene = common.GAMESCREEN
	common.autoplay_timer = common.timer
	get_tree().reload_current_scene()
	setPause(false,"NewGame")

func exit():
	if(type_exists("VFFileOps")):
		common.fileops.setAutoplay(false)
		
	if File.new().file_exists("/dev/shm/mapwriteeveryseconds"):
		if Directory.new().remove("/dev/shm/mapwriteeveryseconds")!=0:
			print("Cannot delete /dev/shm/mapwriteeveryseconds")
	else:
		print("File /dev/shm/mapwriteeveryseconds does not exist")
		
	fadeout()
	yield(self,"fade_finished")

	get_tree().quit()

func show_new_game():
	if(!get_tree().get_current_scene().has_node("NewGame")):
		var new_game = preload("res://common/new_game/new_game.tscn").instance()
		get_tree().get_current_scene().add_child(new_game)
		#get_node("/root/Main/NewGame/C").set_rotation_degrees(get_game_rotation())
		get_node("/root/Main/NewGame").rotate_inside(get_game_rotation())
		setPause(true,"NewGame")
		
func hide_new_game():
	if(get_tree().get_current_scene().has_node("NewGame")):
		var n=get_tree().get_current_scene().get_node("NewGame")
		get_tree().get_current_scene().remove_child(n)
		n.queue_free()
		
		
##### volume setting

func volume_up():
	if(common.options.is_screensaver):
		return
	if(!has_node("VolumeControl")):
		InitVolumeControlScene()
	get_node("VolumeControl").volume_up()

func volume_down():
	if(common.options.is_screensaver):
		return
	if(!has_node("VolumeControl")):
		InitVolumeControlScene()
	get_node("VolumeControl").volume_down()

func InitVolumeControlScene():
	var vc = preload("res://common/volume_control/VolumeControl.tscn").instance()
	add_child(vc)

	vc.position = common.base_viewport_size / 2.0

	vc.scale=get_fixed_scale()

	vc.set_rotation_degrees(get_game_rotation())
	vc.Init()

#### Ability to change scenes
func changeSceneWithFilePath(inPath2Scene):
	changeSceneTo(load(inPath2Scene))

#not updating changeSceneTo to achieve backward compatibility
func guardedDelayedChangeSceneWithPath(inPath2Scene): 
	var newScn = load(inPath2Scene)
	yield(get_tree(),"idle_frame")
	changeSceneTo(newScn)


func changeSceneTo(inSceneInstance):
	if(sceneWaiting2Load!=null): return
	sceneWaiting2Load = inSceneInstance
	var capture = get_viewport().get_texture().get_data()
	capture.flip_y()
	var texture  = ImageTexture.new()
	texture.create_from_image(capture)
	
	if has_node("SceneTransition"):
		get_node("SceneTransition").set_texture(texture)
		get_node("SceneTransition").show()
		get_node("SceneTransition").modulate.a = 1.0
		#yield(get_tree(), "idle_frame")
		get_node("SceneTransition").get_texture().set_flags(0)
		get_node("SceneTransition").position = common.base_viewport_size / 2.0
		
		# scale for different game native resolutions (800/500, 800/600, 1280/800)
		var s=viewport_size/texture.get_size()*camera.zoom
		get_node("SceneTransition").set_scale(s)
		get_node("SceneTransition/Animator").play("transit")

	if(currentGameSceneNode!=null && (currentGameSceneNode.get_ref())):
		currentGameSceneNode.get_ref().set_pause_mode(PAUSE_MODE_STOP)
		currentGameSceneNode.get_ref().queue_free()
		currentGameSceneNode.get_ref().connect("tree_exited", self, "onCurrentGameScenePreparing2ExitTree")


func changeSceneWithFadeoutTo(inSceneInstance):
	fadeout()
	yield(self, "fade_finished")
	changeSceneTo(inSceneInstance)
	fade()


func changeSceneWithFadeoutWithFilePath(inPath2Scene):
	changeSceneWithFadeoutTo(load(inPath2Scene))


func onCurrentGameScenePreparing2ExitTree():
	if(sceneWaiting2Load==null): return
	
	# need to wait one more frame because old scene actually is still in the tree and 
	# in some rare cases godot might register for example body collision between objects from old scene and a new one. 
	# in other words, both scenes are inside scene tree at the same time for some short time.
	yield(get_tree(), "idle_frame")
	
	var newScene = sceneWaiting2Load.instance()
	add_child(newScene)
	currentGameSceneNode = weakref(newScene)
	sceneWaiting2Load = null

