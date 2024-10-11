@tool
extends Node3D

@export_range(-0.99, 0.99) var squash_and_stretch := 0.0:
	set = set_squash_and_stretch

@export_range(1.0, 2.2) var pow_factor := 1.41:
	set = set_pow_factor

@export var reset := false:
	set = set_reset


func set_squash_and_stretch(amount: float) -> void:
	squash_and_stretch = amount
	if is_equal_approx(squash_and_stretch, 0.0):
		scale = Vector3.ONE
		return

	var scale_y: float = pow(1.0 + abs(amount), pow_factor)
	var scale_xz: float = pow(1.0 / (1.0 + abs(amount)), pow_factor / 2)

	if amount > 0.0:
		scale = Vector3(scale_xz, scale_y, scale_xz)
	else:
		scale = Vector3(scale_y, scale_xz, scale_y)


func set_pow_factor(new_factor: float) -> void:
	pow_factor = new_factor
	set_squash_and_stretch(squash_and_stretch)


func set_reset(value: bool) -> void:
	if value:
		scale = Vector3.ONE
		squash_and_stretch = 0.0
		pow_factor = 1.41
