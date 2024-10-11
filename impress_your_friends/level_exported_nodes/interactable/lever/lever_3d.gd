@tool
class_name Lever3D extends Node3D

## Emitted when the state of the is_active property changes.
signal switched(is_active: bool)

@export var is_active := false: set = set_is_active

@export_group("Appearance")
@export var color_inactive := Color.GRAY
@export var color_active := Color.YELLOW

@onready var _sound: AudioStreamPlayer3D = %Sound
@onready var _lever_handle: MeshInstance3D = %LeverHandle
@onready var _lever_tip_material: StandardMaterial3D = _lever_handle.get_surface_override_material(1)
@onready var _area_3d: Area3D = %Area3D


func _ready() -> void:
	set_is_active(is_active)
	_area_3d.input_event.connect(func (
		camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int
	) -> void:
		if event.is_action_pressed("left_click"):
			is_active = not is_active
	)


func set_is_active(new_value: bool):
	if is_active != new_value:
		switched.emit(new_value)

	is_active = new_value
	if not is_inside_tree():
		return

	var color := color_active if is_active else color_inactive
	var angle := -60.0 if is_active else 60.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(_lever_handle, "rotation_degrees:z", angle, 0.2)
	tween.tween_property(_lever_tip_material, "albedo_color", color, 0.2)
	_sound.pitch_scale = randf_range(0.9, 1.1)
	_sound.play()
