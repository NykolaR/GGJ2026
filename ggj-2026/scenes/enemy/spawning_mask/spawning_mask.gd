extends "res://scenes/enemy/enemy.gd"

const CHASING_ENEMY: PackedScene = preload("res://scenes/enemy/chasing_enemy/chasing_enemy.tscn")
const ChasingEnemy: GDScript = preload("res://scenes/enemy/chasing_enemy/chasing_enemy.gd")

@onready var max_health: int = health


func _physics_process(_delta: float) -> void:
	if Helper.player:
		look_at(Helper.player.global_position)


func death() -> void:
	$Glow.hide()
	$CollisionShape3D.disabled = true
	$Mask.scale = Vector3.ONE * 0.2
	$Mask.process_mode = Node.PROCESS_MODE_INHERIT
	$Mask.mask_grabbed.connect(queue_free)
	$Mask.apply_torque_impulse(Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1)))
	$SpawnTimer.stop()
	$RespawnTimer.start()
	set_physics_process(false)


func _on_spawn_timer_timeout() -> void:
	var ne: ChasingEnemy = CHASING_ENEMY.instantiate()
	add_sibling(ne)
	ne.global_transform = $SpawnTransform.global_transform


func _on_respawn_timer_timeout() -> void:
	$Mask.mask_grabbed.disconnect(queue_free)
	$Mask.process_mode = Node.PROCESS_MODE_DISABLED
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Mask, "global_transform", global_transform, 5.0)
	tween.finished.connect(respawned)


func respawned() -> void:
	$Glow.show()
	health = max_health
	$CollisionShape3D.disabled = false
	set_physics_process(true)
	$SpawnTimer.start()
