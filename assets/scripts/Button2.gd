extends Control


var input_duration = 0.1
var input_time = 0
var button_time = 0
var button_loading_time = 1
var declining_speed = 3
var is_timer_ready = true
var is_button_active = false

signal button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	input_time = input_duration
	update_size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_timer_ready:
		button_time = -1
	if input_time < input_duration:
		input_time += delta
		#$TextureProgress.value += \
		if button_time > button_loading_time and is_timer_ready:
			emit_signal("button_pressed")
			$Timer.start()
			is_timer_ready = false
			button_time = 0
		button_time += delta
	else:
		#$TextureProgress.value -= 1
		if button_time > 0:
			button_time -= delta * declining_speed
	#print("button_time", button_time)
	$TextureProgress.value = int(button_time / button_loading_time * $TextureProgress.max_value)
		
	
		
func _on_Button2_gui_input(event):
	input_time = 0
	

func _on_Button2_item_rect_changed():
	update_size()
	pass # Replace with function body.
	
func update_size():
	$TextureProgress.rect_size = rect_size


func _on_Timer_timeout():
	is_timer_ready = true
