extends Node3D


# never plays
func started() -> void:
	var tween: Tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_linear", 0, 2.0)
	tween.finished.connect($AudioStreamPlayer.queue_free)
