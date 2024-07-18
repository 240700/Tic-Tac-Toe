class_name Board
extends Node2D

signal board_changed()

@onready var view: BoardView = $View

var board_array = [
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0]
]


# 根据像素坐标放置棋子
func place_a_piece(pos: Vector2, type: GameRule.PieceType):
	var cell_pos = view.position_to_cell_position(pos)
	place_a_piece_by_cell_pos(cell_pos, type)


# 根据棋盘坐标放置棋子
func place_a_piece_by_cell_pos(pos: Vector2i, type: GameRule.PieceType):
	if pos.x > 2 or pos.x < 0 or pos.y > 2 or pos.y < 0 :
		printerr(pos)
		return
	
	view.place_a_piece(pos, type)
	board_array[pos.x][pos.y] = type
	board_changed.emit()


func is_cell_empty_by_pixel_position(pos: Vector2):
	var cell_pos = view.position_to_cell_position(pos)
	return board_array[cell_pos.x][cell_pos.y] == GameRule.PieceType.EMPTY
