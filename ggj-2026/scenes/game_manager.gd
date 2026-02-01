extends Node

var survived_frames: int = 0


func _ready() -> void:
	set_physics_process(false)
	set_process_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		get_viewport().set_input_as_handled()
		get_tree().reload_current_scene()



func _physics_process(delta: float) -> void:
	survived_frames += 1


func gameover() -> void:
	$AudioStreamPlayer.play()
	set_physics_process(false)
	$GameOver.text = "YOU HAVE PERISHED\n\n"
	var ns: String = "%5.2f" % (survived_frames / 60.0)
	$GameOver.text += "YOU SURVIVED " + ns + " SECONDS"
	set_process_input(true)
