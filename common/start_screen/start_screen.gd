extends Node2D

var delayed = true
var delay_timer = 0.0
var delay = 1.5
var has_tutorial = false

var screen_size
var fullscreen_size
var screen_scale
func _ready():
	screen_size=get_node("/root/Main").viewport_size
	fullscreen_size=get_node("/root/Main").window_size
	screen_scale=screen_size/fullscreen_size

	set_physics_process(true)
	get_node("PartnerLogo").hide()
	get_node("TutorialButton").hide()
	get_node("TutorialVideo").hide()
	get_node("Bundle/BundleLogo").hide()
	get_node("Bundle/BundleLabel").hide()
	get_node("GameCategoryIcon").hide()
	
	$CommonBackground.position=fullscreen_size/2

	var tb=["BackButton","RemoteFlag","TutorialButton"]
	for p in range(tb.size()):
		var n=get_node(tb[p])
		n.position.y=screen_size.y-50
		# some magic numbers to position.
		n.position.x=screen_size.x/2.25 * p+screen_size.x/18
		n.scale=screen_scale
	$RemoteFlag.set_scale(screen_scale)
	$StartButton.set_scale(screen_scale)
	
	$StartButton.position=screen_size*Vector2(0.5,0.76)
	var gtc=Vector2(0,1)*$GameTitle.font.get_size()
	$GameTitle.position=screen_size*Vector2(0.5,0.45)-gtc/2
	$Bundle.position=screen_size*Vector2(0.5,0.5)
	$PartnerLogo.position=screen_size*Vector2(0.125,0.0667)
	$CompanyLogo.position=screen_size*Vector2(0.875,0.0667)
	var title = common.options["label"]

	if(title.length() == 0):
		title = common.options["game_title"]

	if(title.length() > 0):
		title = tr(title)
		if(title.length() < 16):
			get_node("GameTitle").set_font_size(86)
		elif(title.length() < 22):
			get_node("GameTitle").set_font_size(60)
			get_node("GameTitle").set_position(get_node("GameTitle").get_position() + Vector2(0.0, 20.0))
		elif(title.length() < 40):
			get_node("GameTitle").set_font_size(36)
			get_node("GameTitle").set_position(get_node("GameTitle").get_position() + Vector2(0.0, 30.0))
		else:
			get_node("GameTitle").set_font_size(24)
			get_node("GameTitle").set_position(get_node("GameTitle").get_position() + Vector2(0.0, 40.0))
		get_node("GameTitle").animate(title)
	
	var bundle_logo = common.options["bundle_logo"]
	var bundle_label = common.options["bundle_label"]
	
	if(common.options["bundle_label"].length() > 0):
		bundle_label = common.options["bundle_label"]
	
	if(File.new().file_exists(common.options["bundle_logo"])):
		bundle_logo = common.options["bundle_logo"]
		get_node("Bundle/BundleLogo").set_texture(load(common.options["bundle_logo"]))
		get_node("Bundle/BundleLogo").get_texture().set_flags(Texture.FLAG_FILTER)
		get_node("Bundle/BundleLogo").show()
	elif(File.new().file_exists(bundle_logo)):
		get_node("Bundle/BundleLogo").set_texture(load(bundle_logo))
		get_node("Bundle/BundleLogo").get_texture().set_flags(Texture.FLAG_FILTER)
		get_node("Bundle/BundleLogo").show()
	else:
		bundle_logo = ""
		
	if(bundle_label.length() > 0):
		get_node("Bundle/BundleLabel").set_text(bundle_label)
		get_node("Bundle/BundleLabel").show()
		
	if(bundle_logo.length() > 0 and bundle_label.length() > 0):
		var bundle_logo_w = get_node("Bundle/BundleLogo").get_texture().get_width()
		var bundle_label_w = get_node("Bundle/BundleLabel").get_font("font").get_string_size(bundle_label).x
		get_node("Bundle/BundleLogo").set_centered(false)
		get_node("Bundle/BundleLogo").set_position(-Vector2(get_node("Bundle/BundleLogo").get_texture().get_width()*0.5, get_node("Bundle/BundleLogo").get_texture().get_height()*0.5))
		get_node("Bundle/BundleLogo").set_position(Vector2(-(bundle_logo_w+bundle_label_w)*0.5, get_node("Bundle/BundleLogo").get_position().y))
		get_node("Bundle/BundleLabel").set_position(get_node("Bundle/BundleLabel").get_position()+Vector2(bundle_logo_w*0.5, 0.0))

	var game_category_icon = common.options["game_category_icon"]
	if(File.new().file_exists(game_category_icon)):
		get_node("GameCategoryIcon").set_texture(load(game_category_icon))
		get_node("GameCategoryIcon").get_texture().set_flags(Texture.FLAG_FILTER)
		get_node("GameCategoryIcon").show()
		get_node("StartButton").set_position(get_node("StartButton").get_position() + Vector2(0, 50))
		get_node("GameTitle").set_position(get_node("GameTitle").get_position() + Vector2(0, 50))
		
	var partner_logo = common.options["partner_logo"]
	if(File.new().file_exists(partner_logo)):
		get_node("PartnerLogo").set_texture(load(partner_logo))
		get_node("PartnerLogo").get_texture().set_flags(0)
		get_node("PartnerLogo").show()
	
	if(File.new().file_exists(common.options["funtronic_logo"])):
		get_node("CompanyLogo").set_texture(load(common.options["funtronic_logo"]))
		get_node("CompanyLogo").get_texture().set_flags(0)
	
	if(common.options["funtronic_logo_hidden"]):
		get_node("CompanyLogo").hide()
	
	var tutorial = common.options["tutorial"]
	if(File.new().file_exists(tutorial)):
		has_tutorial = true
		get_node("TutorialButton").show()
		get_node("TutorialVideo/VideoPlayer").set_stream(load(tutorial))
	else:
		has_tutorial = false

	if common.options["remote_only"]:
		get_node("RemoteFlag").show()
	else:
		get_node("RemoteFlag").hide()


func back():
	if(!get_node("TutorialVideo").is_playing() and !delayed):
		common.impulse()
		delayed = true
		get_parent().back()
	
func start():
	if(!get_node("TutorialVideo").is_playing() and !delayed):
		common.impulse()
		delayed = true
		get_parent().start()
		queue_free()
	
func tutorial():
	if(!get_node("TutorialVideo").is_playing() and !delayed and has_tutorial):
		common.impulse()
		delayed = true
		get_node("TutorialVideo").play_tutorial()

func _physics_process(delta):
	if(delayed):
		delay_timer += delta
		if(delay_timer >= delay):
			delay_timer = 0.0
			delayed = false

