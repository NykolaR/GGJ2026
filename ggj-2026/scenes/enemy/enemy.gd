extends Area3D

@export var health: int = 5


func hit(damage: int = 0) -> void:
	health -= damage
	if health <= 0:
		death()


func death() -> void:
	queue_free()
