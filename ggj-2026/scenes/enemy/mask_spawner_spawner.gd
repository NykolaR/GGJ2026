extends Node3D

const MASKSPAWNER: PackedScene = preload("res://scenes/enemy/spawning_mask/spawning_mask.tscn")
var mask_spawner_count: int = 2

func start() -> void:
	spawn_spawner()
	_on_timer_timeout()
	$Timer.start()


func _on_timer_timeout() -> void:
	for i in mask_spawner_count:
		if randf() < 0.3:
			spawn_spawner()
		if randf() < 0.05:
			mask_spawner_count += 1


func spawn_spawner() -> void:
	var ns: Node3D = MASKSPAWNER.instantiate()
	ns.position = (Vector3.FORWARD * randf() * 13).rotated(Vector3.UP, randf() * PI * 2.0)
	add_child(ns)
