# This script creates a line of sight that sweeps in a cone.
# Instead of using multiple rays, each frame, the ray changes its direction, ensuring a single raycast is performed.
@tool
class_name SweepingRayCast3D extends RayCast3D

@export_range(0.1, 15.0) var range := 5.0: set = set_range
@export_range(0.01, 60, 0.001, "radians_as_degrees") var sweep_angle := PI / 8.0
@export_range(0.01, 8 * PI) var sweep_speed := PI

var _current_rotation := 0.0


func _physics_process(delta: float) -> void:
	_current_rotation = wrapf(_current_rotation + sweep_speed * delta, 0.0, 2.0 * PI)
	var offset_ray := global_basis.z.rotated(global_basis.y, sweep_angle) * range
	target_position = offset_ray.rotated(global_basis.z, _current_rotation)


func set_range(new_range: float) -> void:
	range = new_range
	target_position = global_basis.z * range
