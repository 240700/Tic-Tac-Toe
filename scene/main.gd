class_name Main extends Node2D

signal game_mode_changed(game_mode: GameRule.GameMode)
signal game_overed(overed: bool)

@onready var board: Board = $Board


var board_dumplicate: Board

var is_game_over: bool = false:
	set = set_game_over

var winner: GameRule.PieceType

var game_mode: GameRule.GameMode :
	set = set_game_mode

var player_list: Array[Player]
# 值为 player_list 索引
var whose_turn: int = 0


func _ready() -> void:
	board_dumplicate = board.duplicate()
	game_mode = GameRule.GameMode.PVE


func _unhandled_input(_event: InputEvent) -> void:
	if _is_npc_turn():
		return
	
	if _event is InputEventMouseButton :
		var event = _event as InputEventMouseButton
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT :
			var pos = board.get_local_mouse_position() 
			if board.view.inner_rect_size.has_point(pos):
				get_viewport().set_input_as_handled()
				
				if is_game_over or _is_npc_turn():
					return
				
				if not board.is_cell_empty_by_pixel_position(pos):
					return
				
				board.place_a_piece(pos, player_list[whose_turn]._type)
				player_list[whose_turn].turned()


func game_start() -> void:
	if _is_npc_turn():
		player_list[whose_turn].turn()


# setter
func set_game_mode(value: GameRule.GameMode) -> void:
	
	#region 初始化数据
	board.queue_free()
	board = board_dumplicate.duplicate()
	add_child(board)
	player_list.clear()
	is_game_over = false
	winner = GameRule.PieceType.EMPTY
	game_mode = value
	whose_turn = 0
	#endregion
	
	match value:
		GameRule.GameMode.PVE:
			pve()
		GameRule.GameMode.PVP:
			pvp()
	
	for player in player_list:
		player.turn_ended.connect(_on_turn_end)
	
	game_mode_changed.emit(game_mode) 
	
	game_start()


func pvp() -> void:
	var play_1 = Player.new(board, GameRule.PieceType.O)
	var play_2 = Player.new(board, GameRule.PieceType.X)
	player_list.append(play_1)
	player_list.append(play_2)


func pve() -> void:
	var player = Player.new(board, GameRule.PieceType.EMPTY)
	var npc = NPC.new(board, GameRule.PieceType.EMPTY)
	player_list.append(player)
	player_list.append(npc)
	player_list.shuffle()
	player_list[0]._type = GameRule.PieceType.O
	player_list[1]._type = GameRule.PieceType.X


func set_game_over(value: bool) -> void:
	is_game_over = value
	game_overed.emit(value)


func _is_npc_turn() -> bool:
	if player_list[whose_turn] is NPC:
		return true
	else :
		return false


func _on_turn_end():
	if GameRule.has_winner(board.board_array):
		winner = GameRule.get_winner(board.board_array)
		is_game_over = true
	elif GameRule.get_empty_cells(board.board_array).size() == 0:
		winner = GameRule.PieceType.EMPTY
		is_game_over = true
	
	if is_game_over :
		return
	
	whose_turn = (whose_turn + 1) % 2
	if _is_npc_turn():
		player_list[whose_turn].turn()


