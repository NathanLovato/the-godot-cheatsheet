extends Node3D

@onready var animation_player = %AnimationPlayer
@onready var ice_spikes = %IceSpikes

func _ready():
	ice_spikes.one_shot = true
	ice_spikes.emitting = true
	animation_player.play("default")
	await animation_player.animation_finished
	queue_free()
