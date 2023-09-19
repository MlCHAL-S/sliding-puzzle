
extends Node2D

var board = []


func gen_board():
	var value = 1
	board = []
	for r in range(4):
		board.append([])
		for c in range(4):

			# fills it with numbers
			if (value == 16):
				board[r].append(0)
			else:
				board[r].append(value)

			value += 1
		
		
func print_board():
	print('------board------')
	for r in range(4):
		var row = ''
		for c in range(4):
			row += str(board[r][c]).pad_zeros(2) + ' '
		print(row)
			
func value_to_grid(value):
	for r in range(4):
		for c in range(4):
			if (board[r][c] == value):
				return Vector2(c, r)
	return null
			
func _ready():
	value_to_grid()
