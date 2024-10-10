## An animated character for the running game.
##
## You can change the playing animation with the [member animation] property, and
## change the character's viewing angle with the [member angle] property.
@tool
class_name RunnerVisual extends Node2D

## Use this enum to tell the runner which animation to play.
enum Animations {
	## A standing animation.
	IDLE,
	## A walking animation.
	WALK,
	## A faster, run animation.
	RUN
}

## Determines where the runner character is looking, in radians.
@export_range(-180.0, 180.0, 0.001, "radians_as_degrees") var angle := 0.0: set = set_angle

## Controls the animation that's currently playing. Use one of the values from the [enum Animations] enum.
@export var animation_name: Animations = Animations.IDLE: set = set_animation_name


@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _animation_state_machine : AnimationNodeStateMachinePlayback = %AnimationTree.get("parameters/StateMachine/playback")

@onready var _anchors: Array[Node2D] = [%FeetAnchor, %HandAnchor, %EarAnchor, %ShoulderAnchor, %HipsAnchor]

@onready var _face: Sprite2D = %Face
@onready var _back: Sprite2D = %Back
@onready var _ear_r: Sprite2D = %EarR
@onready var _ear_l: Sprite2D = %EarL
@onready var _antenna_r: Sprite2D = %AntennaR
@onready var _antenna_l: Sprite2D = %AntennaL
@onready var _hand_r: Sprite2D = %HandR
@onready var _hand_l: Sprite2D = %HandL
@onready var _foot_l: Node2D = %FootL
@onready var _foot_r: Node2D = %FootR
@onready var _shoulder_r: Marker2D = %ShoulderR
@onready var _shoulder_l: Marker2D = %ShoulderL
@onready var _hips_l: Marker2D = %HipsL
@onready var _hips_r: Marker2D = %HipsR
@onready var _arm_r: Line2D = %ArmR
@onready var _arm_l: Line2D = %ArmL
@onready var _leg_r: Line2D = %LegR
@onready var _leg_l: Line2D = %LegL


func _ready() -> void:
	set_animation_name(animation_name)


func set_angle(new_angle: float) -> void:
	if not is_inside_tree():
		return

	angle = new_angle
	var _angle = wrapf(angle, 0.0, TAU)

	for anchor in _anchors:
		anchor.rotation = _angle

	var z_index_value = -1 if _angle > PI else 1
	if is_equal_approx(_angle, 0.0) or is_equal_approx(_angle, PI):
		z_index_value = 0

	var _antenna_offset = -sin(_angle + PI / 2.0)
	_antenna_l.position.x = _antenna_offset * 4.0
	_antenna_r.position.x = -_antenna_offset * 4.0

	_antenna_l.rotation = _antenna_offset * 0.5
	_antenna_r.rotation = -_antenna_offset * 0.5

	_ear_r.z_index = z_index_value
	_ear_l.z_index = -z_index_value

	_arm_r.z_index = z_index_value
	_arm_l.z_index = -z_index_value

	_hand_r.z_index = z_index_value
	_hand_l.z_index = -z_index_value

	_foot_l.rotation = sin(_angle) - _antenna_offset * 0.5
	_foot_r.rotation = sin(_angle) + _antenna_offset * 0.5

	_back.position.x = -remap(wrapf(angle + TAU, 0.0, TAU), 0.0, TAU, -1.0, 1.0) * _face.texture.get_width() * 1.2
	_face.position.x = -remap(wrapf(angle + PI, 0.0, TAU), 0.0, TAU, -1.0, 1.0) * _face.texture.get_width() * 1.2


func _process(_delta: float) -> void:
	_arm_r.points = [_arm_r.to_local(_shoulder_r.global_position), _hand_r.position]
	_arm_l.points = [_arm_l.to_local(_shoulder_l.global_position), _hand_l.position]
	_leg_r.points = [_leg_r.to_local(_hips_r.global_position), _foot_r.position]
	_leg_l.points = [_leg_l.to_local(_hips_l.global_position), _foot_l.position]


func set_animation_name(new_animation_name: Animations) -> void:
	if _animation_state_machine == null:
		return

	if animation_name == new_animation_name:
		return

	animation_name = new_animation_name
	match animation_name:
		Animations.IDLE:
			_animation_state_machine.travel("idle")
		Animations.WALK:
			_animation_state_machine.travel("walk")
		Animations.RUN:
			_animation_state_machine.travel("run")
		_:
			assert(new_animation_name in Animations, "The animation specified for the character visual doesn't exist, please check if there aren't any typos")
