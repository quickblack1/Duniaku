extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 10

var mouse_mode = "captured"
var mouse_sensitivity: float = Settings.mouse_sensitivity
var input_mouse: Vector2
var rotation_target: Vector3
var is_aiming: bool = false
#var aim_pos: Vector3 = Vector3(0.0, 0.1, 0.0) # naik 0.2 meter ke depan
var aim_pos: Vector3
var hip_pos: Vector3       # posisi biasa
var aim_fov: float = 50.0
var hip_fov: float = 70.0
var aim_speed: float = 8.0
var total_bullets: int = 30
var weapon_mode: String = "semi"
var can_shoot: bool = true
var reloading: bool = false
var spotLightOn: bool = false

#@export var bullet_scene: PackedScene

@onready var camera01 = $Head/Camera3D
@onready var muzzle_flash: GPUParticles3D = $Head/Camera3D/AK47/GPUParticles3D
@onready var muzzle: Marker3D = $Head/Camera3D/AK47/Muzzle
@onready var gunshot_sound: AudioStreamPlayer3D = $Head/Camera3D/AK47/AudioStreamPlayer3D
@onready var weapon = $Head/Camera3D/AK47
@onready var weapon_aim = $Head/Camera3D/AK48
@onready var weapon01 = $Head/Camera3D/M4A1
@onready var weapon01_aim = $Head/Camera3D/M4A1_aim
@onready var bullet_remaining : Label = $Label
@onready var spotLight3D: SpotLight3D = $Head/Camera3D/SpotLight3D



func _ready() -> void:
	hip_pos = weapon.position
	aim_pos = weapon_aim.position
	
	#weapon01.position = hip_pos
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#pass

func _process(delta):
	
	
	# toggle aiming bila klik kanan
	if Input.is_action_just_pressed("right_click"):
		is_aiming = !is_aiming
		
		#print(weapon.position)
		#print(hip_pos)

	# tentukan target position ikut is_aiming
	var target_pos = aim_pos if is_aiming else hip_pos
	if weapon.visible:
		weapon.position = weapon.position.lerp(target_pos, aim_speed * delta)
	if weapon01.visible:
		weapon01.position = weapon01.position.lerp(target_pos, aim_speed * delta)
	
	# tentukan target FOV ikut is_aiming
	var target_fov = aim_fov if is_aiming else hip_fov
	camera01.fov = lerp(camera01.fov, target_fov, aim_speed * delta)
	
	bullet_remaining.text = ""
	
	if Input.is_action_just_pressed("1"):
		if weapon.visible:
			if weapon_mode == "semi":
				weapon_mode = "auto"
			else:
				weapon_mode = "semi"
		
		#print(weapon_mode)
		weapon.visible = true
		weapon01.visible = false
		hip_pos = weapon.position
		aim_pos = weapon_aim.position
	
	if Input.is_action_just_pressed("2"):
		weapon.visible = false
		weapon01.visible = true
		hip_pos = weapon01.position
		aim_pos = weapon01_aim.position
	
	if Input.is_action_just_pressed("spotLight"):
		spotLightOn = !spotLightOn
		#print(spotLightOn)
		if spotLightOn:
			spotLight3D.visible = true
		else:
			spotLight3D.visible = false
	

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_cancel"):
		#if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			#mouse_mode = "visible"
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#input_mouse = Vector2.ZERO
		#else:
			#mouse_mode = "captured"
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED:
		camera01.rotation.z = lerp_angle(camera01.rotation.z, input_mouse.x * 25 * delta, delta * 5)
		camera01.rotation.x = lerp_angle(camera01.rotation.x, rotation_target.x, delta * 25)
		rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	
	#if is_on_floor():
		#var collision = move_and_collide(velocity * delta)
		#if collision:
			#var body = collision.get_collider()
			#if body is RigidBody3D:
				#body.apply_central_impulse((body.global_transform.origin - global_transform.origin).normalized() * 5)
	
	if Input.is_action_just_pressed("shoot"):
		if total_bullets >= 1 and can_shoot == true:
			shoot()
		else:
			if reloading == false:
				$AudioStreamPlayer3D.play()
	
	if Input.is_action_just_pressed("reload"):
		reloading = true
		can_shoot = false
		$AudioStreamPlayer3D2.play()
		await $AudioStreamPlayer3D2.finished
		reloading = false
		can_shoot = true
		total_bullets = 30
	
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_mode == "captured":
		input_mouse = event.relative / mouse_sensitivity
		#print(input_mouse)
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity
		#print("rotation target: ",rotation_target)

func shoot():
	gunshot_sound.play()
	var bullet_scene: PackedScene = preload("res://tscn/bullet_01.tscn")
	var bullet := bullet_scene.instantiate() as RigidBody3D
	get_tree().current_scene.add_child(bullet)
	
	total_bullets -= 1
	#print(total_bullets)

	# posisi & rotasi peluru
	bullet.global_transform = muzzle.global_transform

	# arah ikut kamera
	var dir: Vector3 = -camera01.global_transform.basis.z
	bullet.shoot(dir)

	# muzzle flash
	muzzle_flash.restart()
	muzzle_flash.emitting = true
