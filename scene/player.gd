class_name Player

signal turn_ended


var _board: Board
var _type: GameRule.PieceType

func _init(board: Board, type: GameRule.PieceType) -> void:
	_type = type
	_board = board


func turned() -> void:
	turn_ended.emit()

