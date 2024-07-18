@tool

class_name BoardView
extends Node2D

const OUTER_BORDER_WIDTH = 6.0
const INNER_BORDER_WIDTH = 4.0
const CELL_SIDE_LENGTH = 100.0
var length_of_side :float

var rect_size :Rect2 
# 去除外边框的其余部分
var inner_rect_size :Rect2

const X_SCENE :PackedScene = preload("res://scene/piece/x.tscn")
const O_SCENE :PackedScene = preload("res://scene/piece/o.tscn")


func _init() -> void:
	length_of_side = CELL_SIDE_LENGTH*3 \
		+ OUTER_BORDER_WIDTH*2 + INNER_BORDER_WIDTH*2
	
	rect_size = Rect2(0, 0, length_of_side, length_of_side)
	inner_rect_size = rect_size.grow(-OUTER_BORDER_WIDTH)


func _draw() -> void:
	#外边框
	draw_rect(rect_size, Color.BLACK)
	draw_rect(inner_rect_size, Color.WHITE)
	#region 内框
	#竖线
	var x = OUTER_BORDER_WIDTH + CELL_SIDE_LENGTH + INNER_BORDER_WIDTH/2
	draw_line(Vector2(x, 0), Vector2(x,length_of_side), Color.BLACK, INNER_BORDER_WIDTH)
	x += CELL_SIDE_LENGTH + INNER_BORDER_WIDTH
	draw_line(Vector2(x, 0), Vector2(x,length_of_side), Color.BLACK, INNER_BORDER_WIDTH)
	#横线
	var y = OUTER_BORDER_WIDTH + CELL_SIDE_LENGTH + INNER_BORDER_WIDTH/2
	draw_line(Vector2(0, y), Vector2(length_of_side, y), Color.BLACK, INNER_BORDER_WIDTH)
	y += CELL_SIDE_LENGTH + INNER_BORDER_WIDTH
	draw_line(Vector2(0, y), Vector2(length_of_side, y), Color.BLACK, INNER_BORDER_WIDTH)
	#endregion


# row、col 从 0 开始
func get_cell_origin(row:int, col:int) -> Vector2:
	var step = CELL_SIDE_LENGTH + INNER_BORDER_WIDTH
	var x = OUTER_BORDER_WIDTH + CELL_SIDE_LENGTH / 2 + col * step
	var y = OUTER_BORDER_WIDTH + CELL_SIDE_LENGTH / 2 + row * step
	return Vector2(x, y)


# 将输入的坐标，变为row、col这样的单元格坐标表示
# - pos(Vector2) : 
func position_to_cell_position(pos :Vector2) -> Vector2i:
	pos -= Vector2(OUTER_BORDER_WIDTH, OUTER_BORDER_WIDTH)
	var row = pos.y / (inner_rect_size.size.y/3)
	var col = pos.x / (inner_rect_size.size.x/3)
	return Vector2(row, col)


func place_a_piece(pos: Vector2i, type: GameRule.PieceType) -> void:
	var new_node:Node2D
	match type :
		GameRule.PieceType.X:
			new_node = X_SCENE.instantiate()
		GameRule.PieceType.O:
			new_node = O_SCENE.instantiate()
		
	new_node.position = get_cell_origin(pos.x, pos.y)
	add_child(new_node)
