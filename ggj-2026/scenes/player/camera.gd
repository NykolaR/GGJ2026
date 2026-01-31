extends Node3D

@export var sens: Vector2 = Vector2(0.01, 0.01)

var _last_mouse_motion: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_last_mouse_motion = event.screen_relative


func _process(delta: float) -> void:
	rotate_y(_last_mouse_motion.x * -sens.x)
	$RotX.rotate_x(_last_mouse_motion.y * -sens.y)
	$RotX.rotation_degrees.x = clampf($RotX.rotation_degrees.x, -50, 70)
	_last_mouse_motion = Vector2.ZERO
