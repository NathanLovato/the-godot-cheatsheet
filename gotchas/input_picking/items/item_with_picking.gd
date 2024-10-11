# Script for pickable items. We don't use inheritance here, just composition: an item is any Area2D scene with a child sprite and this script attached. See gem.tscn and health_pack.tscn.
extends Area2D


func _ready() -> void:
	play_floating_animation()


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)

	if event_is_mouse_click:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(get_node("Sprite2D"), "scale", Vector2(0.0, 0.0), 0.3)
		tween.finished.connect(queue_free)


func play_floating_animation() -> void:
	var tween := create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)

	var sprite_2d := get_node("Sprite2D")
	var position_offset := Vector2(0.0, 4.0)
	var duration = randf_range(0.8, 1.2)
	sprite_2d.position = -1.0 * position_offset
	tween.tween_property(sprite_2d, "position", position_offset, duration)
	tween.tween_property(sprite_2d, "position",  -1.0 * position_offset, duration)
