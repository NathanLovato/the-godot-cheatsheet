@tool
extends Node3D

@export var linked_lever: Lever3D = null

var _is_active := false: set = _set_is_active
var _tween: Tween = null
## Stores the last rotation of the gears when the connected device was stopped.
## This is so when the connected device is started again, the gears continue rotating from where they left off.
var _last_stop_rotation_degrees = 0.0

@onready var _big_gear = %BigGear
@onready var _small_gear = %SmallGear
@onready var _sound = %Sound


func _ready() -> void:
	if linked_lever != null:
		linked_lever.switched.connect(_set_is_active)
		_set_is_active(linked_lever.is_active)
	_set_is_active(_is_active)


func _set_is_active(new_state: bool) -> void:
	_is_active = new_state

	if not is_inside_tree():
		return

	if _tween && _tween.is_valid():
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_parallel(true)
	
	var sound_db := 0.0 if new_state else -80.0
	var sound_tween := create_tween()
	sound_tween.tween_property(_sound, "volume_db", sound_db, 0.5)
	
	if new_state:
		_tween.set_loops(0)
		_tween.tween_method(_animate_gears_rotation, _last_stop_rotation_degrees, _last_stop_rotation_degrees + 360.0, 2.0)
		_sound.play()
	else:
		_tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		_tween.tween_method(
			_animate_gears_rotation, _last_stop_rotation_degrees, _last_stop_rotation_degrees + 25.0, 0.5
		)
		
		sound_tween.tween_callback(_sound.stop)


func _animate_gears_rotation(progress: float) -> void:
	_last_stop_rotation_degrees = progress
	_big_gear.rotation_degrees.y = progress
	_small_gear.rotation_degrees.y = -progress
	
