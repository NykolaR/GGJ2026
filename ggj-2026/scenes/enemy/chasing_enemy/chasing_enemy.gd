extends "res://scenes/enemy/enemy.gd"

@export var speed: float = 0.04
@export var steer_speed: float = 0.03


func _physics_process(_delta: float) -> void:
	if Helper.player:
		var nt: Transform3D = global_transform
		nt = nt.looking_at(Helper.player.global_position)
		var rate: float = maxf(remap(-global_basis.z.dot(global_position.direction_to(Helper.player.global_position)), -1, 1, 0.001, steer_speed), 0.01)
		global_basis = global_basis.slerp(nt.basis, rate)
	
	global_position += global_basis.z * -speed
