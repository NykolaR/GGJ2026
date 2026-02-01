extends RigidBody3D

const MaskBase: GDScript = preload("res://scenes/enemy/spawning_mask/bases/mask_base.gd")

var base: MaskBase

signal mask_grabbed

func _ready() -> void:
	base = Helper.mask_bases.pick_random().instantiate()
	$Base.add_child(base)
	add_cols($Base.get_children())


func add_cols(from: Array) -> void:
	for child in from:
		if child is CollisionShape3D:
			var nc: CollisionShape3D = child.duplicate()
			add_child(nc)


func pick_up_mask() -> void:
	mask_grabbed.emit()
