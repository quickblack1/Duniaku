extends VehicleBody3D

#@export var MAX_STEER = 0.5
#@export var ENGINE_POWER = 500
@export var max_engine_force := 1500.0
@export var brake_force := 50.0
@export var max_steer := 0.4

@onready var speed_label = $"SpeedLabel"
@onready var popup: PopupPanel = $PopupPanel
@onready var btn: Button = $PopupPanel/VBoxContainer/Button
@onready var button2: Button = $PopupPanel/VBoxContainer/Button2

var engine_on := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if engine_on:
		btn.visible = false
		button2.visible = true
		#$Engine_start.play()
	else:
		btn.visible = true
		button2.visible = false

func _physics_process(_delta: float) -> void:
	#steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	var steer := Input.get_action_strength("ui_right") \
			   - Input.get_action_strength("ui_left")

	for wheel in get_children():
		if wheel is VehicleWheel3D and wheel.use_as_steering:
			wheel.steering = -steer * max_steer
	
	if engine_on == true:
		var throttle := Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")

		# Daya enjin
		for wheel in get_children():
			if wheel is VehicleWheel3D and wheel.use_as_traction:
				wheel.engine_force = -throttle * max_engine_force

		# Brake
		if Input.is_action_pressed("brake"):
			for wheel in get_children():
				if wheel is VehicleWheel3D:
					wheel.brake = brake_force
		else:
			for wheel in get_children():
				if wheel is VehicleWheel3D:
					wheel.brake = 0.0
	
	
		
		
		#if not $AudioStreamPlayer3D.playing:
		#	$AudioStreamPlayer3D.play()
	
	#show car speed
	var forward_speed = -transform.basis.z.dot(linear_velocity)
	var speed_kmh = forward_speed * 3.6
	speed_label.text = "Speed: %d km/h" % abs(speed_kmh)
	
	#if engine_on == true:
		#$Engine_start.play()

func _on_engine_start_finished():
	$AudioStreamPlayer3D.play()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		popup.popup(Rect2(event.position, popup.size))
		#btn.visible = true
		#btn.global_position = event.position
	if event.is_action_pressed("left_click"):
		pass
		#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_up"):
		if engine_on:
			$Engine_start.stop()
			if not $AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.play()

func _on_button_pressed() -> void:
	if not engine_on:
		engine_on = true
		#print(engine_on)
		$Engine_start.play()
		popup.visible = false
		#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
		#tunggu bunyi start habis, baru idle loop
		$Engine_start.finished.connect(_on_engine_start_finished, CONNECT_ONE_SHOT)


func _on_button_2_pressed() -> void:
	$Engine_start.stop()
	$AudioStreamPlayer3D.stop()
	engine_on = false
