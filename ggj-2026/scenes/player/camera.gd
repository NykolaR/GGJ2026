extends Node3D

@export var sens: Vector2 = Vector2(0.01, 0.01)
@export var csens: Vector2 = Vector2.ONE * 5.0
@onready var rot_x: Node3D = $RotX as Node3D

var _last_mouse_motion: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_last_mouse_motion = event.screen_relative


func _process(delta: float) -> void:
	rotate_y(_last_mouse_motion.x * -sens.x)
	rot_x.rotate_x(_last_mouse_motion.y * -sens.y)
	rot_x.rotation_degrees.x = clampf(rot_x.rotation_degrees.x, -50, 70)
	controller_camera(delta)
	_last_mouse_motion = Vector2.ZERO


func controller_camera(delta: float) -> void:
	_last_mouse_motion = Input.get_vector(&"camera_left", &"camera_right", &"camera_up", &"camera_down") * delta
	rotate_y(_last_mouse_motion.x * -csens.x)
	rot_x.rotate_x(_last_mouse_motion.y * -csens.y)
	rot_x.rotation_degrees.x = clampf(rot_x.rotation_degrees.x, -50, 70)
