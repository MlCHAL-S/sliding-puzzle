extends Control

export var size = 4
export var tile_size = 80
export var tile_scene: PackedScene
export var slide_duration = 0.15

var board = []
var tiles = []
var empty = Vector2()
var is_animating = false
var tiles_animating = 0

var move_count = 0
var number_visible = true
var background_texture = null

enum GAME_STATES {
	NOT_STARTED,
	STARTED,
	WON
}

var game_state = GAME_STATES.NOT_STARTED

signal game_started
signal game_won
signal moves_updated

func gen_board():
	var value = 1
	board = []
	for r in range(size):
		board.append([])
		for c in range(size):

			# choose which is empty cell
			if (value == size*size):
				board[r].append(0)
				empty = Vector2(c, r)
			else:
				board[r].append(value)

				# generate a new tile
				var tile = tile_scene.instance()
				tile.set_position(Vector2(c * tile_size, r * tile_size))
				tile.set_text(value)
				if background_texture:
					tile.set_sprite_texture(background_texture)
				tile.set_sprite(value-1, size, tile_size)
				tile.set_number_visible(number_visible)
				tile.connect("tile_pressed", self, "_on_Tile_pressed")
				tile.connect("slide_completed", self, "_on_Tile_slide_completed")
				add_child(tile)
				tiles.append(tile)

			value += 1

func is_board_solved(board):
	var value = 1
	for i in range(size):
		for j in range(size):
			# r == c and c == size - 1 and board[r][c] == 0
			if board[i][j] != value:
				if j == i and board[i][j] == 0:
					return true
				else:
					return false
			value += 1

func value_to_grid(value):
	for r in range(size):
		for c in range(size):
			if (board[r][c] == value):
				return Vector2(c, r)
	return null
	
	
func get_tile_by_value(value):
	for tile in tiles:
		if str(tile.number) == str(value):
			return tile
	return null
	
	
func _ready():
	tile_size = floor(get_size().x / size)
	set_size(Vector2(tile_size*size, tile_size*size))
	gen_board()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
