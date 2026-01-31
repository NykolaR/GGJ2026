extends "res://scenes/enemy/enemy.gd"


func death() -> void:
	$MeshInstance3D.hide()
	$CollisionShape3D.disabled = true
	$Mask.process_mode = Node.PROCESS_MODE_INHERIT
	$Mask.mask_grabbed.connect(queue_free)
	$Mask.apply_torque_impulse(Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1)))
