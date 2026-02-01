extends Node

var survived_frames: int = 0


func _ready() -> void:
	set_physics_process(false)
	set_process_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		get_tree().reload_current_scene()



func _physics_process(delta: float) -> void:
	survived_frames += 1


func gameover() -> void:
	set_physics_process(false)
	$GameOver.text = "YOU HAVE PERISHED\n\n"
	$GameOver.text += "YOU SURVIVED " + str(survived_frames / 60.0) + " SECONDS"
	set_process_input(true)
