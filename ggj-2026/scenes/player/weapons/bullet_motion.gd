extends Area3D

const Enemy: GDScript = preload("res://scenes/enemy/enemy.gd")

@export var damage: int = 1
@export var speed: float = 0.1
@export var spread: float = 0.02
@export var grav: float = 0.002
@export var lifetime: float = 3
@export var piercing: bool = false


func _ready() -> void:
	$Timer.wait_time = lifetime
	$Timer.start()
	rotate_x(randf_range(-spread, spread))
	rotate_y(randf_range(-spread, spread))
	rotate_z(randf_range(-spread, spread))
	top_level = true


func _physics_process(_delta: float) -> void:
	global_position += global_basis.z * -speed
	global_position += Vector3.DOWN * grav


func _on_area_entered(area: Area3D) -> void:
	if area is Enemy:
		area.hit(damage)
		if not piercing:
			queue_free()


func _on_body_entered(_body: Node3D) -> void:
	queue_free()
