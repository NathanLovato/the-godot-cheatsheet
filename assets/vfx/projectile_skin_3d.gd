@tool
class_name ProjectileSkin3D extends Node3D


## Virtual function. Override to define the skin's appear animation.
func appear() -> void:
	pass


## Virtual function. Override to define the skin's destroy animation and destroy the node when the animation is done.
func destroy() -> void:
	pass
