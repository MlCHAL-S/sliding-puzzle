extends Sprite

func _ready():
	position=common.base_viewport_size/2
	scale=get_node("/root/Main").get_fixed_scale()

	show()
	common.has_difficulty = true

func set_difficulty(level):
	get_parent().set_difficulty(level)
	common.has_difficulty = false

func show():
	set_p()
	.show()

func hide():
	set_p(false)
	.hide()

func set_visible(b):
	set_p(b)
	.set_visible(b)

func set_p(b=true):
	$"1".set_pickable(b)
	$"2".set_pickable(b)
	
func left():
	get_node("1").animate()

func right():
	get_node("2").animate()

func set_custom_background(scene):
	$CommonBackground.hide()
	add_child_below_node($CommonBackground,scene)

func do_not_prescale():
	return true

func back():
	if is_visible():
		hide()
	return false
