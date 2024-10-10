## Script for playing Gobot's animations and controlling its 3D model.
##
## This class is associated with the GobotSkin3D scene.
## It exposes an API to play various animations and rotate the model's
## hips independently from the head.
class_name GobotSkin3D extends Node3D

## Emitted when Gobot's feet hit the ground will running.
signal foot_step

## Gobot's MeshInstance3D model.
@export var gobot_mesh: MeshInstance3D = null

## Controls the rotation of Gobot's hips and legs, relative to the skin's current rotation.
var hips_rotation := 0.0: set = set_hips_rotation

var _tween_damage: Tween = null
var _emission_blend := 0.0: set = _set_emission_blend
var _blink = true: set = _set_blink
var _left_eye_mat_override := 1
var _right_eye_mat_override := 2
var _open_eye_texture: CompressedTexture2D = preload("textures/open_eye.png")
var _closed_eye_texture: CompressedTexture2D = preload("textures/closed_eyes.png")

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get(
	"parameters/StateMachine/playback"
)

@onready var _flip_shot_path := "parameters/FlipShot/request"
@onready var _hurt_shot_path := "parameters/HurtShot/request"

@onready var _blink_timer = %BlinkTimer
@onready var _closed_eyes_timer = %ClosedEyesTimer

@onready var _body_material := preload("res://assets/skins/gobot/materials/gobot_mat.tres")
@onready var _left_eye_mat: StandardMaterial3D = gobot_mesh.get_surface_override_material(_left_eye_mat_override)
@onready var _right_eye_mat: StandardMaterial3D = gobot_mesh.get_surface_override_material(_right_eye_mat_override)
@onready var _skeleton_3d: Skeleton3D = $Gobot/rig/Skeleton3D
@onready var _hips_bone_id: int = _skeleton_3d.find_bone("Hips")


func _ready():
	_emission_blend = 0.0
	_blink_timer.timeout.connect(
		func() -> void:
			_left_eye_mat.albedo_texture = _closed_eye_texture
			_right_eye_mat.albedo_texture = _closed_eye_texture
			_closed_eyes_timer.start(0.2)
	)
	_closed_eyes_timer.timeout.connect(
		func() -> void:
			_left_eye_mat.albedo_texture = _open_eye_texture
			_right_eye_mat.albedo_texture = _open_eye_texture
			_blink_timer.start(randf_range(1.0, 8.0))
	)


#ANCHOR:function_examples
## Sets the model to a neutral, action-free state.
func idle():
	_state_machine.travel("Idle")


## Sets the model to a running animation or forward movement.
func run():
	_state_machine.travel("Run")
#END:function_examples


## Sets the model to an upward-leaping animation, simulating a jump.
func jump():
	_state_machine.travel("Jump")

## Sets the model to a downward animation, imitating a fall.
func fall():
	_state_machine.travel("Fall")


## Sets the model to an edge-grabbing animation.
func edge_grab():
	_state_machine.travel("EdgeGrab")


## Sets the model to a wall-sliding animation.
func wall_slide():
	_state_machine.travel("WallSlide")


## Plays a one-shot front-flip animation.
## This animation does not play in parallel with other states.
func flip():
	_animation_tree.set(_flip_shot_path, true)


## Makes a victory sign.
func victory_sign():
	_state_machine.travel("VictorySign")


## Plays a one-shot hurt animation.
## This animation plays in parallel with other states.
func hurt():
	if _tween_damage != null:
		_tween_damage.kill()

	_tween_damage = create_tween()
	_emission_blend = 1.0
	_tween_damage.tween_property(self, "_emission_blend", 0.0, 0.2)

	_animation_tree.set(_hurt_shot_path, true)
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1.2, 0.8, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)


func set_hips_rotation(value: float):
	hips_rotation = fposmod(value, TAU)
	var base_transform : Transform3D = _skeleton_3d.get_bone_global_rest(_hips_bone_id)
	_skeleton_3d.set_bone_global_pose_override(_hips_bone_id, base_transform.rotated(Vector3.UP, hips_rotation), 1.0)


func _set_emission_blend(value := 0.0) -> void:
	_emission_blend = clamp(value, 0.0, 1.0)
	_body_material.set_shader_parameter("emission_intensity", value)


func _set_blink(state: bool):
	if _blink == state:
		return
	_blink = state
	if _blink:
		_blink_timer.start(0.2)
	else:
		_blink_timer.stop()
		_closed_eyes_timer.stop()
