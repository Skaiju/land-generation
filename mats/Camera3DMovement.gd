extends Camera3D

var target_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	target_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector3(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"),
		Input.get_axis("move_forward", "move_back")
	)
	
	if direction == Vector3.ZERO: return
	
	target_pos += 40 * delta * direction
	
func _physics_process(delta):
	position = lerp(position,target_pos, 0.8)
