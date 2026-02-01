extends Node

enum GUNS {NONE, PISTOL, MACHINE, SHOTGUN, HARPOON}
enum MODIFIERS {NONE}

var mask_bases: Array[PackedScene] = [
	preload("res://scenes/enemy/spawning_mask/bases/mask_base_butterfly.tscn"),
	preload("res://scenes/enemy/spawning_mask/bases/mask_base_diamond.tscn"),
	preload("res://scenes/enemy/spawning_mask/bases/mask_base_goblin.tscn"),
	preload("res://scenes/enemy/spawning_mask/bases/mask_base_heart.tscn")
]

var player: Node3D


func _ready() -> void:
	randomize()
	randomize()
	randomize()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("uncapture_mouse"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
