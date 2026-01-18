extends DirectionalLight3D

@export var day_duration_minutes: int = 60

@export var day_color: Color = Color(1.0, 0.95, 0.85)
@export var night_color: Color = Color(0.1, 0.1, 0.25)

@export var day_energy: float = 1.5
@export var night_energy: float = 0.05
@export var intensity: float
@export var world_env: WorldEnvironment
@export var day_bg_energy := 1.0
@export var night_bg_energy := 0.05

var time: int = 0   # dalam MINIT
var t: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	$Timer.timeout.connect(_on_minute_passed)
	
	var file := FileAccess.open("res://json/savegame.json", FileAccess.READ)
	var text := file.get_as_text()
	file.close()

	var data = JSON.parse_string(text)
	var time2 = data["time"]
	time = time2.minute
	
	t = float(time) / float(day_duration_minutes)
	var sun_angle: float = lerp(0.0, -180.0, t)
	print(sun_angle)
	rotation_degrees.x = sun_angle
	intensity = sun_curve(t)
	light_energy = lerp(night_energy, day_energy, intensity)
	light_color = night_color.lerp(day_color, intensity)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#pass
	$Label.text = str(time)
	$Label2.text = "light energy: " + str(light_energy)
	$Label3.text = "intensity: " + str(intensity)

func _on_minute_passed() -> void:
	time += 1
	if time >= day_duration_minutes:
		time = 0
	
	t = float(time) / float(day_duration_minutes)
	var sun_angle: float = lerp(0.0, -360.0, t)
	rotation_degrees.x = sun_angle
	intensity = sun_curve(t)
	light_energy = lerp(night_energy, day_energy, intensity)
	light_color = night_color.lerp(day_color, intensity)
	
	update_environment(t)
	
	#var file := FileAccess.open("res://json/savegame.json", FileAccess.WRITE)
	#
	#var hour: int = floor(time / 60.0)
	#var minute: int = time % 60
	#$Label.text = "Waktu: %02d:%02d" % [jam, minit]
	
	#var data := {
		#"time": {
			#"hour": hour,
			#"minute": minute
		#}
	#}
	#file.store_string(JSON.stringify(data))
	#file.close()
#
	#print("Game disimpan")
	
func sun_curve(t2: float) -> float:
	# -1 (tengah malam) → 0 (subuh) → 1 (tengah hari)
	var v := sin(t2 * TAU)
	return clamp(v, 0.0, 1.0)

func update_environment(t2: float) -> void:
	intensity = sun_curve(t2)

	if world_env and world_env.environment:
		world_env.environment.background_energy_multiplier = lerp(night_bg_energy, day_bg_energy, intensity)
