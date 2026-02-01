extends CharacterBody3D

const BULLET: PackedScene = preload("res://scenes/player/weapons/bullet.tscn")
const Bullet: GDScript = preload("res://scenes/player/weapons/bullet.gd")
const BULLET_MOTION: PackedScene = preload("res://scenes/player/weapons/bullet_motion.tscn")
const BulletMotion: GDScript = preload("res://scenes/player/weapons/bullet_motion.gd")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var baked_gun: Helper.GUNS = Helper.GUNS.NONE
var baked_gun_level: int = 0
var gun: Helper.GUNS = Helper.GUNS.NONE: set = set_gun

@export var camera: Node3D
@onready var animation: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var pistol_bullet_spawn: Node3D = $"RotY/RotX/hand/Arm-Armature/Skeleton3D/Arm/PistolBulletSpawn" as Node3D

@onready var sgbs: Array[Node3D] = [
	$"RotY/RotX/hand/Arm-Armature/Skeleton3D/SG1/SG", $"RotY/RotX/hand/Arm-Armature/Skeleton3D/SG2/SG", $"RotY/RotX/hand/Arm-Armature/Skeleton3D/SG3/SG", $"RotY/RotX/hand/Arm-Armature/Skeleton3D/SG4/SG"
]


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$RotY/RotX/hand.look_at($"RotY/RotX/hand/Arm-Armature/Skeleton3D/Arm/PistolBulletTarget".global_position)
	Helper.player = $RotY
	set_gun(Helper.GUNS.NONE)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	
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
	
	match gun:
		Helper.GUNS.PISTOL:
			if Input.is_action_just_pressed(&"shoot"):
				animation.start(&"Pistol-shoot")
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			elif Input.is_action_pressed(&"shoot"):
				animation.travel(&"Pistol-shoot")
		Helper.GUNS.SHOTGUN:
			if Input.is_action_pressed(&"shoot"):
				animation.travel(&"Shotgun-shoot")
		Helper.GUNS.MACHINE:
			if Input.is_action_pressed(&"shoot"):
				animation.travel(&"MachineShoot")


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	match anim_name:
		&"Pistol-shoot":
			var b: Bullet = BULLET.instantiate()
			b.damage = baked_gun_level + 1
			b.target = $"RotY/RotX/hand/Arm-Armature/Skeleton3D/Arm/PistolBulletTarget".global_position
			pistol_bullet_spawn.add_child(b)
		&"Shotgun-shoot":
			for i in (baked_gun_level + 2):
				for sg in sgbs:
					var b: BulletMotion = BULLET_MOTION.instantiate()
					b.damage = 1
					b.lifetime = 0.5
					b.speed = 0.4
					b.spread = 0.15
					sg.add_child(b)
		&"MachineShoot":
			var b: BulletMotion = BULLET_MOTION.instantiate()
			b.damage = baked_gun_level + 1
			b.speed = 0.25
			b.spread = 0.03
			pistol_bullet_spawn.add_child(b)
			$RotY._last_mouse_motion += Vector2(randf_range(-5, 5), randf_range(-7, -1))


func set_gun(new: Helper.GUNS) -> void:
	gun = new
	match gun:
		Helper.GUNS.NONE:
			animation.start(&"Rest")
		Helper.GUNS.PISTOL:
			animation.start(&"Pistol-idle")
		Helper.GUNS.MACHINE:
			animation.start(&"Machine-idle")
		Helper.GUNS.SHOTGUN:
			animation.start(&"Shotgun-idle")
