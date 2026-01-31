extends CharacterBody3D

const BULLET: PackedScene = preload("res://scenes/player/weapons/bullet.tscn")
const Bullet: GDScript = preload("res://scenes/player/weapons/bullet.gd")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var camera: Node3D
@onready var animation: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var pistol_bullet_spawn: Node3D = $"RotY/RotX/hand/Arm-Armature/Skeleton3D/Arm/PistolBulletSpawn" as Node3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$RotY/RotX/hand.look_at($"RotY/RotX/hand/Arm-Armature/Skeleton3D/Arm/PistolBulletTarget".global_position)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("uncapture_mouse"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if Input.is_action_just_pressed(&"shoot"):
		animation.start(&"Pistol-shoot")
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_pressed(&"shoot"):
		animation.travel(&"Pistol-shoot")


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	match anim_name:
		&"Pistol-shoot":
			var b: Bullet = BULLET.instantiate()
			b.target = $"RotY/RotX/hand/Arm-Armature/Skeleton3D/Arm/PistolBulletTarget".global_position
			pistol_bullet_spawn.add_child(b)
