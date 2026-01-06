extends DirectionalLight3D

@export var day_duration_minutes: float = 60.0

@export var day_color: Color = Color(1.0, 0.95, 0.85)
@export var night_color: Color = Color(0.1, 0.1, 0.25)

@export var day_energy: float = 1.5
@export var night_energy: float = 0.05

var time: float
var day_duration_seconds: float

func _ready() -> void:
	day_duration_seconds = day_duration_minutes * 60.0
	time = randf_range(0.0, day_duration_seconds)
	print(time)

func _process(delta: float) -> void:
	time += delta
	if time > day_duration_seconds:
		time = 0.0

	var t: float = time / day_duration_seconds

	# rotate matahari
	var sun_angle: float = lerp(-90.0, 270.0, t)
	rotation_degrees.x = sun_angle

	var intensity: float = sun_curve(t)

	light_energy = lerp(night_energy, day_energy, intensity)
	light_color = night_color.lerp(day_color, intensity)

func sun_curve(t: float) -> float:
	return clamp(sin(t * PI), 0.0, 1.0)
