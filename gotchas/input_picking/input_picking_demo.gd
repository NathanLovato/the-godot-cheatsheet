extends Node

func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
