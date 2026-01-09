extends DirectionalLight3D

@export var day_duration_minutes: int = 60

@export var day_color: Color = Color(1.0, 0.95, 0.85)
@export var night_color: Color = Color(0.1, 0.1, 0.25)

@export var day_energy: float = 1.5
@export var night_energy: float = 0.05

var time: int = 0   # dalam MINIT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	$Timer.timeout.connect(_on_minute_passed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#pass
	#var jam: int = floor(time / 60.0)
	var _minit: int = time % 60

	#$Label.text = "Waktu: %02d:%02d" % [jam, minit]

func _on_minute_passed() -> void:
	time += 1
	if time >= day_duration_minutes:
		time = 0
	var t: float = float(time) / float(day_duration_minutes)
	var sun_angle: float = lerp(0.0, 360.0, t)
	rotation_degrees.x = sun_angle
	var intensity: float = sun_curve(t)
	light_energy = lerp(night_energy, day_energy, intensity)
	light_color = night_color.lerp(day_color, intensity)

func sun_curve(t: float) -> float:
	return clamp(sin(t * PI), 0.0, 1.0)
