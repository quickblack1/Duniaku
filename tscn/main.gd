extends Node3D

@onready var player: CharacterBody3D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	load_game()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

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
	#health = data["health"]
	#time = data["time"]
	#ammo = data["ammo"]

	print("Game dimuatkan")


func _on_timer_timeout() -> void:
	#pass # Replace with function body.
	save_game()
