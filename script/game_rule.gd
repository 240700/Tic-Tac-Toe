class_name GameRule
extends Node

enum GameMode {PVE = 0, PVP = 1}

enum PieceType {X= -1, O= 1, EMPTY= 0}


static func has_winner(board_array) -> bool:
	#检查行
	for i in 3:
		if board_array[i][0] == 0:
			continue
		if board_array[i][0] == board_array[i][1] and board_array[i][1] == board_array[i][2]:
			return true
			
	#检查列
	for i in 3:
		if board_array[0][i] == 0:
			continue
		if board_array[0][i] == board_array[1][i] and board_array[1][i] == board_array[2][i]:
			return true
			
	#检查对角
	if board_array[0][0] != 0 and \
		board_array[0][0] == board_array[1][1] and \
		board_array[1][1] == board_array[2][2]:
		return true
	if board_array[0][2] != 0 and \
		board_array[0][2] == board_array[1][1] and \
		board_array[1][1] == board_array[2][0]:
		return true
	
	return false


static func get_winner(board_array) -> GameRule.PieceType:
	var piece_count = 0
	for i in board_array.size():
		for j in board_array[i].size():
			if board_array[i][j] != 0:
				piece_count += 1
	
	return PieceType.O if piece_count % 2 else PieceType.X


static func get_empty_cells(board_array) -> Array[Vector2i]:
	var empty_cells: Array[Vector2i] = []
	
	for i in board_array.size():
		for j in board_array[i].size():
			if board_array[i][j] == 0:
				empty_cells.append(Vector2i(i, j))
		
	return empty_cells
