extends RigidBody3D


signal mask_grabbed

func _ready() -> void:
	$Base.add_child(Helper.mask_bases.pick_random().instantiate())
	add_cols($Base.get_children())


func add_cols(from: Array) -> void:
	for child in from:
		if child is CollisionShape3D:
			var nc: CollisionShape3D = child.duplicate()
			add_child(nc)


func pick_up_mask() -> void:
	mask_grabbed.emit()
