extends SpringArm3D

@export var mouse_sensibility: float = Settings.mouse_sensitivity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED:
			rotation.y -= event.relative.x * mouse_sensibility
			rotation.y = wrapf(rotation.y, 0.0, TAU)
			
			rotation.x -= event.relative.y * mouse_sensibility
			rotation.x = clamp(rotation.x, -PI/2, PI/4)
		
	if event.is_action_pressed("wheel_up"):
		spring_length -= 1
	if event.is_action_pressed("wheel_down"):
		spring_length += 1

	if event.is_action_pressed("toggle_mouse_capture"):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		else:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
