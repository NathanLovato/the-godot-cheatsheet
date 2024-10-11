@tool
class_name MovingPlatform3D extends Node3D

## Reference to the lever that controls the platform's movement.
@export var linked_lever: Lever3D = null:
	set = set_linked_lever
## Target marker node for the platform to move to. The platform will not move without a target marker.
## In the editor, changing the position of the end marker will update the platform's end position.
## At runtime, the end position is set only once when the platform is activated.
@export var end_marker: Marker3D = null:
	set = set_end_marker

## When this property is set to true, the platform moves between its start position and the end marker in an infinite cycle.
## When set to false, the platform moves back to its starting position and stays there.
## If there's a linked_lever, the platform's active state is controlled by the lever. Otherwise, it can be toggled via the is_active property.
@export var is_active := false:
	set = set_is_active

@export_group("Appearance")
@export var color_active := Color.GREEN
@export var color_inactive := Color.GRAY
## Reference to the platform mesh's material. This is used to change the color of the platform when it is active.
@export var platform_material: StandardMaterial3D = null

@export_group("Animation")
@export var pause_duration := 1.5
@export var move_duration := 2.0

var _tween: Tween = null
var _end_position := Vector3.ZERO

@onready var _start_position := global_position
@onready var _platform: Node3D = %AnimatableBody3D


func _ready() -> void:
	_platform.global_position = _start_position
	end_marker = end_marker
	set_linked_lever(linked_lever)


# This should only run in the editor. See [method set_end_marker] for more information.
func _physics_process(_delta: float) -> void:
	var last_start_position := _start_position
	_start_position = global_position
	if last_start_position.distance_squared_to(_start_position) > 0.01:
		_start_position = global_position

	if end_marker == null:
		return

	var last_end_position = _end_position
	_end_position = end_marker.global_position
	if last_end_position.distance_squared_to(_end_position) > 0.01:
		set_is_active(is_active)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	if not end_marker:
		warnings.append(
			"The platform needs an end marker to know where to move to. It should be a node that extends Marker3D. Please assign one in the Inspector."
		)
	if not platform_material:
		warnings.append(
			"The platform needs a material to change its color when it is active. Please assign one to the Platform Material property in the Inspector."
		)
	return warnings


func set_linked_lever(new_value: Lever3D) -> void:
	if linked_lever != null and linked_lever.switched.is_connected(set_is_active):
		linked_lever.switched.disconnect(set_is_active)

	linked_lever = new_value
	if not is_inside_tree():
		return

	linked_lever = new_value
	if linked_lever != null:
		linked_lever.switched.connect(set_is_active)
		set_is_active(linked_lever.is_active)


func set_end_marker(new_value: Marker3D) -> void:
	end_marker = new_value
	if end_marker == null or not is_inside_tree():
		return

	_end_position = end_marker.global_position
	set_physics_process(Engine.is_editor_hint() and end_marker != null)


func set_is_active(new_value: bool) -> void:
	is_active = new_value

	if not is_inside_tree() or end_marker == null:
		return

	var color := color_active if is_active else color_inactive
	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween()
	if is_active:
		_tween.set_loops(0)
		_tween.tween_property(_platform, "global_position", _end_position, move_duration).set_delay(
			pause_duration
		)
		(
			_tween
			. tween_property(_platform, "global_position", _start_position, move_duration)
			. set_delay(pause_duration)
		)
	else:
		_tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		_tween.tween_property(_platform, "global_position", _start_position, move_duration)

	var tween_color := create_tween()
	tween_color.tween_property(platform_material, "albedo_color", color, 0.2)
