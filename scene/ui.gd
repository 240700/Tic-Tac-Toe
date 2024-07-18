extends CanvasLayer


@export var main: Main

@onready var vs_npc_button: Button = $VS_NPC
@onready var pvp_button: Button = $PVP
@onready var panel: Panel = $Panel
@onready var o: Node2D = $Panel/VBoxContainer/WinnerBar/O
@onready var x: Node2D = $Panel/VBoxContainer/WinnerBar/X

@onready var draw: Label = $Panel/VBoxContainer/draw

@onready var winner_bar: HBoxContainer = $Panel/VBoxContainer/WinnerBar


func _ready() -> void:
	main.game_mode_changed.connect(_game_mode_changed)
	main.game_overed.connect(_game_overed)


func _game_mode_changed(game_mode: GameRule.GameMode):
	if game_mode == GameRule.GameMode.PVE:
		vs_npc_button.grab_focus()
	else:
		pvp_button.grab_focus()
	

func _game_overed(overed: bool):
	
	if overed :
		match main.winner:
			GameRule.PieceType.O:
				winner_bar.show()
				o.show()
			GameRule.PieceType.X:
				winner_bar.show()
				x.show()
			GameRule.PieceType.EMPTY:
				draw.show()
		
		panel.show()
	else:
		o.hide()
		x.hide()
		draw.hide()
		winner_bar.hide()
		panel.hide()


func _on_restart_pressed() -> void:
	main.game_mode = main.game_mode


func _on_vs_npc_pressed() -> void:
	main.game_mode = GameRule.GameMode.PVE


func _on_pvp() -> void:
	main.game_mode = GameRule.GameMode.PVP
