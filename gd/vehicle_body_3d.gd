extends VehicleBody3D

@export var MAX_STEER = 0.5
@export var ENGINE_POWER = 500

@onready var speed_label = $"SpeedLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("ui_up", "ui_down") * ENGINE_POWER
	
	#show car speed
	var forward_speed = -transform.basis.z.dot(linear_velocity)
	var speed_kmh = forward_speed * 3.6
	speed_label.text = "Speed: %d km/h" % abs(speed_kmh)
