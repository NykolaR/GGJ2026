extends Area3D

@export var health: int = 5


func hit(damage: int = 1) -> void:
	$AudioStreamPlayer3D.play()
	health -= maxi(damage, 1)
	if health <= 0:
		death()


func death() -> void:
	queue_free()
