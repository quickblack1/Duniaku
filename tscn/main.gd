extends Node3D

@onready var player: CharacterBody3D = $Player

var hour: int = 0
var minute: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	#load_game()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	#$Timer.timeout.connect(_on_minute_passed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#pass
	if Input.is_action_just_pressed("ui_cancel"):
		$CanvasLayer/PanelContainer.visible = !$CanvasLayer/PanelContainer.visible
	
func save_game():
	var file := FileAccess.open("res://json/savegame.json", FileAccess.WRITE)

	var data := {
		"player_pos": {
			"x": player.global_position.x,
			"y": player.global_position.y,
			"z": player.global_position.z
		},
		"time": {
			"hour": hour,
			"minute": minute
		}
		
	}
	file.store_string(JSON.stringify(data))
	file.close()

	print("Game disimpan")

func load_game():
	if not FileAccess.file_exists("res://json/savegame.json"):
		print("Tiada save")
		return

	var file := FileAccess.open("res://json/savegame.json", FileAccess.READ)
	var text := file.get_as_text()
	file.close()

	var data = JSON.parse_string(text)

	var pos = data["player_pos"]
	player.global_position = Vector3(pos.x, pos.y, pos.z)
	#var time = data["time"]
	#health = data["health"]
	var time = data["time"]
	minute = time.minute
	#ammo = data["ammo"]

	print("Game dimuatkan")


func _on_timer_timeout() -> void:
	#pass # Replace with function body.
	minute += 1
	if minute == 60:
		minute = 0
		hour += 1
	save_game()
