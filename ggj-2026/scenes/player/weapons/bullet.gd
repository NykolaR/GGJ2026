extends RayCast3D

const Enemy: GDScript = preload("res://scenes/enemy/enemy.gd")

var target: Vector3 = Vector3.ZERO

@export var damage: int = 1
@export var spread: float = 0.02
@export var range: float = 10.0

@onready var visual: Node3D = $Visual as Node3D


func _ready() -> void:
	target_position = Vector3(0, 0, -range)
	look_at(target)
	rotate_x(randf_range(-spread, spread))
	rotate_y(randf_range(-spread, spread))
	rotate_z(randf_range(-spread, spread))


func _physics_process(_delta: float) -> void:
	force_raycast_update()
	visual.scale.z = range
	if is_colliding():
		visual.scale.z = global_position.distance_to(get_collision_point())
		top_level = true
		var col: Enemy = get_collider() as Enemy
		if col:
			col.hit(1)
	
	show()
	set_physics_process(false)
	get_tree().create_timer(0.1).timeout.connect(queue_free)
