extends Node3D

@export var day_duration_minutes: float = 60.0
# 1 hari game = 60 minit dunia sebenar

var time_seconds: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	var day_seconds := day_duration_minutes * 60.0

	# tambah masa
	time_seconds += delta

	# ulang hari
	if time_seconds >= day_seconds:
		time_seconds = 0.0

	update_clock()

func update_clock() -> void:
	#var total: int = int(time_seconds)
	var total: int = floor(time_seconds)
	#print(total)
	var hour: int = int(total / 3600.0) % 24
	#print(hour)
	#var hour: int = total % 3600
	var minute: int = int(total / 60.0) % 60
	var second: int = total % 60

	$Label.text = "%02d:%02d:%02d" % [hour, minute, second]
