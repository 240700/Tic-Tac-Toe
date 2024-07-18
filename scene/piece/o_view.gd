@tool
extends Node2D

var rect_size = Vector2(100, 100)

func _draw() -> void:
	draw_arc(Vector2.ZERO, 40, 0, TAU, 40, Color.GREEN, 10, true)

