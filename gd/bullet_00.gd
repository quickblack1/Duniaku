extends RigidBody3D

@export var speed: float = 700.0
@export var life_time: float = 60.0

func _ready() -> void:
	#pass
	# Auto delete lepas beberapa saat
	await get_tree().create_timer(life_time).timeout
	queue_free()

func _process(_delta: float) -> void:
	pass

func shoot(direction: Vector3) -> void:
	randomize()
	speed = randf_range(0.0, speed)
	#print(speed)
	#apply_central_impulse(direction * speed)
	linear_velocity = direction.normalized() * speed
	#apply_impulse(Vector3.ZERO, direction * speed)
