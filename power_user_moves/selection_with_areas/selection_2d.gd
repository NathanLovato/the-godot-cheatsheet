## Draws selection boxes and detects when you select one or multiple units at once.
extends Area2D

var _selection_rect := Rect2(Vector2.ZERO, Vector2.ZERO)
var _box_selection_distance_threshold := 3.0
var _detected_units := []
var _selected_units := []

@onready var _collision_shape: CollisionShape2D = %CollisionShape2D


func _ready() -> void:
	set_process(false)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action("left_click"):
		return

	if event.is_action_pressed("left_click"):
		_start_selection(event.position)
	elif event.is_action_released("left_click"):
		_end_selection(event.position)
	queue_redraw()


func _process(_delta: float) -> void:
	_selection_rect.end = get_local_mouse_position()
	_collision_shape.shape.size = abs(_selection_rect.size)
	_collision_shape.position = _selection_rect.position + _selection_rect.size / 2.0

	_detected_units = get_overlapping_areas()
	if (_selection_rect.size.length() < _box_selection_distance_threshold
		and not _detected_units.is_empty()):
		_select_top_node(_detected_units)
	else:
		_selected_units = _detected_units
	queue_redraw()


func _draw() -> void:
	const SELECTION_OUTLINE_WIDTH := 4.0
	const SELECTION_COLOR := Color(0.301961, 0.65098, 1)

	if monitoring:
		draw_rect(_selection_rect, SELECTION_COLOR, false, SELECTION_OUTLINE_WIDTH)

	for unit: Area2D in _selected_units:
		draw_rect(
			Rect2(unit.position, Vector2.ZERO).grow(100.0),
			SELECTION_COLOR,
			false,
			SELECTION_OUTLINE_WIDTH
		)


func _start_selection(mouse_position: Vector2) -> void:
	_selection_rect.position = mouse_position
	_toggle_selection_state(true)


func _end_selection(mouse_position: Vector2) -> void:
	_selection_rect.end = mouse_position
	_toggle_selection_state(false)
	if (
		not _detected_units.is_empty()
		and _selection_rect.size.length() < _box_selection_distance_threshold
	):
		_select_top_node(_detected_units)


func _select_top_node(nodes: Array) -> void:
	nodes.sort_custom(func _sort_by_tree_order(a: Node, b: Node) -> bool:
		return a.get_index() > b.get_index())
	_selected_units = nodes.slice(0, 1)


func _toggle_selection_state(value: bool) -> void:
	monitoring = value
	set_process(monitoring)
