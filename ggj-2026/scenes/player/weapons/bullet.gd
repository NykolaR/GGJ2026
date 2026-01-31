extends RayCast3D


var target: Vector3 = Vector3.ZERO

@export var spread: float = 0.02
@export var range: float = 10.0

@onready var visual: Node3D = $Visual as Node3D


func _ready() -> void:
	visual.scale.z = range
	target_position = Vector3(0, 0, -range)
	look_at(target)
	rotate_x(randf_range(-spread, spread))
	rotate_y(randf_range(-spread, spread))
	rotate_z(randf_range(-spread, spread))


func _physics_process(_delta: float) -> void:
	force_raycast_update()
	if is_colliding():
		pass
	queue_free()
