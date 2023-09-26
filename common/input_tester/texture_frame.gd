extends TextureRect

var editable_image
var image_size = Vector2(800, 600)
var image_format = Image.FORMAT_RGBA8
var image_texture
var timer = 0.0
var delay = 3.0
var pixels_to_draw = PoolVector2Array()
var inputs_counter = 0

func _ready():
	editable_image = Image.new()
	image_texture = ImageTexture.new()
	
	#editable_image = Image(image_size.x, image_size.y, false, image_format)

	image_texture.create(image_size.x,image_size.y, image_format, 0)    
	image_texture.set_data(editable_image)
	set_texture(image_texture)
	get_parent().get_node("Sensitivity").set_text("Sensitivity: "+str(common.options["sensitivity"]))
	set_physics_process(true)
	set_process_unhandled_key_input(true)

func _physics_process(delta):
	timer += delta
	if(timer > delay):
		timer = 0.0
		pixels_to_draw = PoolVector2Array()
		inputs_counter = 0

func _on_Area2D_input_event(viewport, event, shape_idx):
	pixels_to_draw.push_back(event.position)
	inputs_counter += 1
	get_parent().get_node("InputsCounter").set_text("Inputs count: "+str(inputs_counter))
	update()

func _draw():
	for p in pixels_to_draw:
		draw_circle(p, 2.0, Color(1.0, 0.0, 0.0))

func _unhandled_key_input(key_event):
	if(key_event.scancode == KEY_S and key_event.shift and key_event.pressed):
		common.set_sensitivity(common.options["sensitivity"]+1)
		get_parent().get_node("Sensitivity").set_text("Sensitivity: "+str(common.options["sensitivity"]))
	elif(key_event.scancode == KEY_S and !key_event.shift and key_event.pressed):
		common.set_sensitivity(common.options["sensitivity"]-1)
		get_parent().get_node("Sensitivity").set_text("Sensitivity: "+str(common.options["sensitivity"]))


