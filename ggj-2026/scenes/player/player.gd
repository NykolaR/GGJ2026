extends CharacterBody3D

const Mask: GDScript = preload("res://scenes/mask/mask.gd")

const BULLET: PackedScene = preload("res://scenes/player/weapons/bullet.tscn")
const Bullet: GDScript = preload("res://scenes/player/weapons/bullet.gd")
const BULLET_MOTION: PackedScene = preload("res://scenes/player/weapons/bullet_motion.tscn")
const BulletMotion: GDScript = preload("res://scenes/player/weapons/bullet_motion.gd")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var health: int = 10: set = set_health

var baked_gun: Helper.GUNS = Helper.GUNS.NONE
var baked_gun_level: int = 0
var gun: Helper.GUNS = Helper.GUNS.NONE: set = set_gun

var fuse_percent: float = 0
var fusing_mask: String = "none"

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

	fuse_percent += 0.001
	
	if fuse_percent >= 1.0:
		fuse_percent = 1.0
		
	if fuse_percent >= 1.0:
		baked_gun_level = 2
	elif fuse_percent >= 0.5:
		baked_gun_level = 1
	else:
		baked_gun_level = 0
		
	$"FaceCam/skull-shape/skull".set_blend_shape_value(0, 0.0)
	$"FaceCam/skull-shape/skull".set_blend_shape_value(1, 0.0)
	$"FaceCam/skull-shape/skull".set_blend_shape_value(2, 0.0)
	$"FaceCam/skull-shape/skull".set_blend_shape_value(3, 0.0)
		
	match fusing_mask:
		"butterfly":
			$"FaceCam/skull-shape/skull".set_blend_shape_value(0, fuse_percent)
		"diamond":
			$"FaceCam/skull-shape/skull".set_blend_shape_value(1, fuse_percent)
		"heart":
			$"FaceCam/skull-shape/skull".set_blend_shape_value(2, fuse_percent)
		"goblin":
			$"FaceCam/skull-shape/skull".set_blend_shape_value(3, fuse_percent)
	
	if global_position.y < -3:
		queue_free()


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	match anim_name:
		&"Pistol-shoot":
			var b: Bullet = BULLET.instantiate()
			b.damage = baked_gun_level + 1
			b.target = $"RotY/RotX/hand/Arm-Armature/Skeleton3D/Arm/PistolBulletTarget".global_position
			pistol_bullet_spawn.add_child(b)
			%Shoot.play()
		&"Shotgun-shoot":
			for i in (baked_gun_level + 2):
				for sg in sgbs:
					var b: BulletMotion = BULLET_MOTION.instantiate()
					b.damage = 1
					b.lifetime = 0.5
					b.speed = 0.4
					b.spread = 0.15
					sg.add_child(b)
			%Shoot2.play()
		&"MachineShoot":
			var b: BulletMotion = BULLET_MOTION.instantiate()
			b.damage = baked_gun_level + 1
			b.speed = 0.25
			b.spread = 0.03
			pistol_bullet_spawn.add_child(b)
			$RotY._last_mouse_motion += Vector2(randf_range(-5, 5), randf_range(-7, -1))
			%Shoot.play()


func set_gun(new: Helper.GUNS) -> void:
	$"FaceCam/skull-shape/heart".hide()
	$"FaceCam/skull-shape/goblin".hide()
	$"FaceCam/skull-shape/butterfly".hide()
	$"FaceCam/skull-shape/diamond".hide()
	
	if gun == Helper.GUNS.NONE and not new == Helper.GUNS.NONE:
		var tween: Tween = create_tween()
		tween.tween_property($OmniLight3D, "light_energy", 1.0, 1.0)
	
	gun = new
	if gun == Helper.GUNS.HARPOON:
		gun = Helper.GUNS.PISTOL
		$"FaceCam/skull-shape/diamond".show()
		animation.start(&"Pistol-idle")
		add_mask("diamond")
	else:
		match gun:
			Helper.GUNS.NONE:
				animation.start(&"Rest")
			Helper.GUNS.PISTOL:
				animation.start(&"Pistol-idle")
				$"FaceCam/skull-shape/heart".show()
				add_mask("heart")
			Helper.GUNS.MACHINE:
				animation.start(&"Machine-idle")
				$"FaceCam/skull-shape/goblin".show()
				add_mask("goblin")
			Helper.GUNS.SHOTGUN:
				animation.start(&"Shotgun-idle")
				$"FaceCam/skull-shape/butterfly".show()
				add_mask("butterfly")
				
func _on_mask_body_entered(body: Node3D) -> void:
	if body is Mask:
		gun = body.base.type
		body.pick_up_mask()
		body.queue_free()


func add_mask(mask: String) -> void:
	if mask == fusing_mask:
		fuse_percent += 0.1
	else: 
		fusing_mask = mask
		fuse_percent = 0.0


func fuse_mask() -> void:
	pass


var ht: Tween
func set_health(new: int) -> void:
	health = new
	%Hurt.play()
	if ht:
		ht.kill()
	ht = create_tween()
	$FaceCam/OmniLight3D.light_color = Color.RED
	ht.tween_property($FaceCam/OmniLight3D, "light_color", Color.WHITE, 0.2)
	if health <= 0:
		queue_free()
