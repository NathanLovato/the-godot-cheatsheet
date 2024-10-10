class_name GridIterator2D extends RefCounted

var dimensions := Vector2i(10, 10): set = set_dimensions
var current_position := Vector2i(0, 0)


func set_dimensions(new_dimensions: Vector2i) -> void:
	if new_dimensions.x < 0 or new_dimensions.y < 0:
		printerr("GridIterator2D: dimensions must be positive")
		return
	dimensions = new_dimensions


func _iter_init(_iteration_state: Array) -> bool:
	current_position = Vector2i(0, 0)
	return dimensions.x > 0 or dimensions.y > 0


func _iter_next(_iteration_state) -> bool:
	current_position.x += 1
	if current_position.x >= dimensions.x:
		current_position.x = 0
		current_position.y += 1
	return current_position.y < dimensions.y


func _iter_get(_iteration_state) -> Vector2i:
	return current_position
