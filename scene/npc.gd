class_name NPC
extends Player

func turn() ->void:
	place_a_piece()
	turned()


func place_a_piece() -> void:
	var pos: Vector2i = _best_pos()
	_board.place_a_piece_by_cell_pos(pos, _type)


func _best_pos() -> Vector2i:
	if _board.board_array[1][1] == 0:
		return Vector2i(1, 1)
	
	var best_pos: Vector2i = alpha_beta(_board.board_array.duplicate(), true).pos
	return best_pos


## board_array: 二维数组型 Array[Array[int]]，为棋盘对象的副本
func alpha_beta(board_array, maximizingPlayer: bool, alpha = -INF, beta = INF) -> AlphaBetaResult:
	
	var empty_cells = GameRule.get_empty_cells(board_array)
	
	#判断游戏是否结束
	if GameRule.has_winner(board_array):
		var winner = GameRule.get_winner(board_array)
		var score
		if winner == _type : 
			score = 1
		else: 
			score = -1
		return AlphaBetaResult.new(score)
	elif empty_cells.is_empty():
		return AlphaBetaResult.new()
		
	var best_pos : AlphaBetaResult = AlphaBetaResult.new()
	if maximizingPlayer:
		best_pos.score = -INF
		for cell in empty_cells:
			board_array[cell.x][cell.y] = _type
			var result = alpha_beta(board_array, false, alpha, beta)
			board_array[cell.x][cell.y] = GameRule.PieceType.EMPTY
			result.pos.x = cell.x
			result.pos.y = cell.y 
			if result.score > best_pos.score:
				best_pos = result
			
			alpha = maxf(alpha, best_pos.score)
			if beta <= alpha :
				break
	else :
		best_pos.score = INF
		for cell in empty_cells:
			board_array[cell.x][cell.y] = _type * -1
			var result = alpha_beta(board_array, true, alpha, beta)
			board_array[cell.x][cell.y] = GameRule.PieceType.EMPTY
			result.pos.x = cell.x
			result.pos.y = cell.y 
			if result.score < best_pos.score:
				best_pos = result
			
			beta = minf(beta, best_pos.score)
			if beta <= alpha :
				break
	
	return best_pos


class AlphaBetaResult :
	var score: float
	var pos: Vector2i
	
	func _init(_score: float = 0.0, _pos: Vector2i = Vector2i(-1, -1)):
		self.score = _score
		self.pos = _pos
		
	func _to_string() -> String:
		return "score: %s, pos: %s" % [score, pos]
