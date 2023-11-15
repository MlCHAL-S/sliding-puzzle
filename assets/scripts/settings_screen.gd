extends MarginContainer

signal board_size_update
signal show_numbers_update
signal hide_settings
signal background_update

onready var size_value = $M/V/M/G/SizeValue
onready var button = $M/V/Button2.connect("button_pressed", self, "on_back_pressed")
onready var increase = $M/V/M/G/Decrease.connect("button_pressed", self, "on_increase_pressed")
onready var decrease = $M/V/M/G/Increase.connect("button_pressed", self, "on_decrease_pressed")

var current_size = 4

func _ready():
	$M/V/Button2/Label.text = "Back"
	$M/V/M/G/Decrease/Label.text = "<"
	$M/V/M/G/Decrease/Timer.wait_time = 0.01
	$M/V/M/G/Increase/Label.text = ">"
	$M/V/M/G/Increase/Timer.set_wait_time(0.01)

func _on_SizeSlider_value_changed(value):
	size_value.text = str(value)
	emit_signal("board_size_update", value)


func _on_ShowNumbers_toggled(button_pressed):
	emit_signal("show_numbers_update", button_pressed)


func on_back_pressed():
	emit_signal("hide_settings")

		

func on_increase_pressed():
	if current_size > 3:
		current_size -= 1
	size_value.text = str(current_size)
	emit_signal("board_size_update", current_size)


func on_decrease_pressed():
	if current_size < 7:
		current_size += 1
	size_value.text = str(current_size)
	emit_signal("board_size_update", current_size)


