extends Area3D


func _ready() -> void:
	body_entered.connect(func (_body_that_entered: PhysicsBody3D) -> void:
		await get_tree().process_frame
		Events.kill_plane_touched.emit()
	)
