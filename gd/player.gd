extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 10

var mouse_mode = "captured"
var mouse_sensitivity = 700
var input_mouse: Vector2
var rotation_target: Vector3

@onready var camera01 = $Head/Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
	
	camera01.rotation.z = lerp_angle(camera01.rotation.z, input_mouse.x * 25 * delta, delta * 5)
	camera01.rotation.x = lerp_angle(camera01.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_mode == "captured":
		input_mouse = event.relative / mouse_sensitivity
		#print(input_mouse)
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity
		#print("rotation target: ",rotation_target)
