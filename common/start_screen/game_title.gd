
extends Node2D

export (Font) var font
export (Font) var font_ovr
export (ShaderMaterial) var letter_material

var labels = []
var opacity = 1.0
var index = 0
var animating = false
var animating_backward = false
var custom_name = " "
var timer = 0.0
var ended = false

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if(animating):
		timer += delta
		opacity += delta * 10.0
		if(opacity < 1.0):
			labels[index].get_material().set_shader_param("opacity", opacity)
		else:
			labels[index].get_material().set_shader_param("opacity", 1.0)
			opacity = 0.0
			index += 1
		if(index == labels.size()):
			animating = false
			ended = true
			opacity = 1.0
			index = 0
	if(animating_backward):
		timer += delta
		opacity -= delta * 8.0
		if(opacity > 0.0):
			labels[index].get_material().set_shader_param("opacity", opacity)
		else:
			labels[index].get_material().set_shader_param("opacity", 0.0)
			opacity = 1.0
			index += 1
		if(index == labels.size()):
			animating_backward = false
			ended = true
			opacity = 0.0
			index = 0

func animate(text_to_animate):
	for l in range(labels.size()):
		labels[l].hide()
		labels[l].queue_free()
	labels = []

	if common.is_rtl():
		if(!animating and text_to_animate.length() > 0):
			timer = 0.0
			index = 0
			custom_name = text_to_animate
			animating = true
			animating_backward = false
			ended = false
			var label = Label.new()
			label.set_material(letter_material.duplicate())
			label.add_font_override("font", font)
			var arstr=common.rtl_str(custom_name);
			label.set_text(arstr);
			label.set_position(Vector2(-0.5*label.get_font("font").get_string_size(arstr).x, 0.0))
			label.get_material().set_shader_param("opacity", 0.0)
			labels.append(label)
			add_child(label)
		return
		
	if(!animating):
		timer = 0.0
		index = 0
		custom_name = text_to_animate
		animating = true
		ended = false
		for l in range(labels.size()):
			labels[l].free()
		labels = []
		for i in range(custom_name.length()):
			var label = Label.new()
			label.set_material(letter_material.duplicate())
			if font.get_string_size("A").x<=1:
				label.add_font_override("font", font_ovr)
			else:
				label.add_font_override("font", font)
			label.set_text(custom_name.substr(i,1))
			if(i == 0):
				label.set_position(Vector2(-0.5*label.get_font("font").get_string_size(custom_name).x, 0.0))
			else:
				label.set_position(Vector2(labels[i-1].get_begin().x + labels[i-1].get_font("font").get_string_size(labels[i-1].get_text()).x, 0.0))
			label.get_material().set_shader_param("opacity", 0.0)
			labels.append(label)
			add_child(label)

func animate_backward():
	animating_backward = true 
	ended = false

func ended():
	return ended

func set_text_color(c):
	for i in range(labels.size()):
		labels[i].get_material().set_shader_param("HSV", c)

func set_font_size(size):
	font.set_size(size)

