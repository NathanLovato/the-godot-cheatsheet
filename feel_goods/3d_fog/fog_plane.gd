@tool
extends Node3D

@export var fog_color := Color(0.34901961684227, 0.37647059559822, 1):
	set(new_color):
		fog_color = new_color
		if fog == null:
			return
		fog.material_override.albedo_color = new_color

@export_range(0.1, 12.0) var fog_distance := 4.0:
	set(new_distance):
		fog_distance = new_distance
		if fog == null:
			return
		fog.material_override.proximity_fade_distance = new_distance

@onready var fog: MeshInstance3D = %Fog


func _ready() -> void:
	fog_distance = fog_distance
	fog_color = fog_color
