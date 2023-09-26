extends MarginContainer

signal board_size_update
signal show_numbers_update
signal hide_settings
signal background_update

onready var size_value = $M/V/M/G/SizeValue
onready var file_dialog = $M/FileDialog
onready var message_popup = $M/PopupMessage

var current_size = 4

func _on_SizeSlider_value_changed(value):
	size_value.text = str(value)
	emit_signal("board_size_update", value)


func _on_ShowNumbers_toggled(button_pressed):
	emit_signal("show_numbers_update", button_pressed)


func _on_BackButton_pressed():
	emit_signal("hide_settings")


func _on_FileButton_pressed():
	file_dialog.popup()

func _on_FileDialog_file_selected(path):
	print('path ', path)

	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		message_popup.setup("Error Occured", "There was an error importing the image.")
		message_popup.popup()
		return

	message_popup.setup("Success", "The background image was changed successully.")
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	message_popup.popup()
	emit_signal("background_update", texture)



func _on_DecreaseButton_pressed():
	if current_size > 2:
		current_size -= 1
	size_value.text = str(current_size)
	emit_signal("board_size_update", current_size)


func _on_IncreaseButton_pressed():
	if current_size < 7:
		current_size += 1
	size_value.text = str(current_size)
	emit_signal("board_size_update", current_size)

