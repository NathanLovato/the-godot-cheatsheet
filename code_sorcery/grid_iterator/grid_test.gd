@tool
extends Node2D

const GRID_SIZE := Vector2i(5, 5)

var grid_iterator := preload("grid_iterator_2d.gd").new()


func _ready() -> void:
	grid_iterator.dimensions = GRID_SIZE
	queue_redraw()


func _draw() -> void:
	const CELL_SIZE := Vector2(60, 60)
	const CELL_SPACING := Vector2(10, 10)

	var grid_size_pixels := (CELL_SIZE + CELL_SPACING) * Vector2(GRID_SIZE) - CELL_SPACING
	var start_position := -grid_size_pixels / 2

	for current_cell: Vector2i in grid_iterator:
		var rect_position := start_position + (CELL_SIZE + CELL_SPACING) * Vector2(current_cell)
		var rect := Rect2(rect_position, CELL_SIZE)
		draw_rect(rect, Color.WHITE, false)
