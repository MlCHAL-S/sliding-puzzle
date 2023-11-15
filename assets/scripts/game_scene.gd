extends Control

var is_started = false
var game_won = false
var start_epoch
var current_epoch

onready var board = $MarginContainer/VBoxContainer/HSplitContainer2/GameView/board
onready var overlay = $MarginContainer/VBoxContainer/HSplitContainer2/GameView/StartOverlay
onready var move_value = $MarginContainer/VBoxContainer/HSplitContainer2/Moves/MoveValue
onready var timer_value = $MarginContainer/VBoxContainer/HSplitContainer2/Time/TimeValue
onready var start_button = $MarginContainer/VBoxContainer/HSplitContainer2/GameView/Start
onready var start_button_text = $MarginContainer/VBoxContainer/HSplitContainer2/GameView/Start/Label

onready var anim_player = $AnimationPlayer

signal game_started

func _ready():
	overlay.visible = true
	$MarginContainer/VBoxContainer/HSplitContainer/Restart.connect("button_pressed", self, "on_restart_pressed")
	$MarginContainer/VBoxContainer/HSplitContainer/Restart/Label.text = "Restart"
	$MarginContainer/VBoxContainer/HSplitContainer/Options.connect("button_pressed", self, "on_options_pressed")
	$MarginContainer/VBoxContainer/HSplitContainer/Options/Label.text = "Options"
	
	start_button.connect("button_pressed", self, "on_start_pressed")
	start_button_text.text = "Start"

func _process(_delta):
	if is_started:
		current_epoch = OS.get_ticks_msec()
		var time_since_game_start = current_epoch - start_epoch
		timer_value.text = str(floor(time_since_game_start/1000)) + ' s'
	else:
		if not game_won:
			timer_value.text = '0 s'

func on_start_pressed():
	start_epoch = OS.get_ticks_msec()
	overlay.visible = false
	start_button.visible = false
	is_started = true
	game_won = false
	on_restart_pressed()
	board._on_Tile_pressed(0)
	


func _on_Board_game_won():
	start_button_text.text = 'Play again'
	overlay.visible = true
	start_button.visible = true
	is_started = false
	game_won = true


func on_restart_pressed():
	if not is_started:
		return
	board.reset_move_count()
	board.scramble_board()
	board.game_state = board.GAME_STATES.STARTED
	start_epoch = OS.get_ticks_msec()
	is_started = true


func _on_Board_moves_updated(move_count):
	board.set_tile_button_visible(false)
	move_value.text = str(move_count)


func _on_SettingsScreen_board_size_update(new_size):
	board.update_size(new_size)
#	overlay.visible = true
	is_started = false
	on_start_pressed()
	


func _on_SettingsScreen_show_numbers_update(state):
	board.set_tile_numbers(state)


func on_options_pressed():
	anim_player.play("show_settings")


func _on_SettingsScreen_hide_settings():
	anim_player.play_backwards("show_settings")

	
func back():
	get_tree().current_scene.changeSceneWithFilePath("res://assets/scenes/menu_screen.tscn")
	return true
