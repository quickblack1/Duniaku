extends RayCast3D

@onready var a = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	#pass
	if is_colliding():
		#pass
		var hit = get_collider()
		if hit != null and hit.is_in_group("weapons"):
			#var a:Label = $Label
			#print(a)
			#print(hit.name)
			a.visible = true
		
			if Input.is_action_just_pressed("interact"):
				hit.queue_free()
	else:
		a.visible = false
