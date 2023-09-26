extends Sprite
var screen_size
func _ready():
	screen_size=common.get_window_size()
	var ss=screen_size
	$DefaultBackground.color=Color("1c2158")
	$DefaultBackground.polygon=[-ss,ss*Vector2(1,-1),ss,ss*Vector2(-1,1)]
	
	var img = common.options["bg_image"]
	if(File.new().file_exists(img)): 
		$Background.texture=load(img)
		$Background.texture.set_flags(0)
		$Background.scale=screen_size/$Background.texture.get_size()
		$Background.position=screen_size/2
		$Background.show()
	else: 
		var color = common.options["bg_color"]
		if(color.is_valid_html_color()): 
			get_node("DefaultBackground").set_color(Color(color))
	
	if(!common.options["bg_particles"]):
		get_node("Particles2D").hide()
