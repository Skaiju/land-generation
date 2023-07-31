extends Node3D

var target_pos: Vector3
var direction: Vector3
var zoom_speed = 1
var target_near 
var rot_speed = 1
@onready var cam : Camera3D = $Camera3D
# Called when the node enters the scene tree for the first time.
func _ready():
	target_pos = position
	direction = Vector3.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = get_rotation_degrees() + Vector3(0, Input.get_axis("move_left", "move_right") * rot_speed,0)
	
	if direction == Vector3.ZERO: return
	#target_pos += 40 * delta * direction
	
	set_rotation_degrees(direction)
	var zoom_direction = Input.get_axis("zoom_in", "zoom_out")

func _physics_process(delta):
	#position = lerp(position,target_pos, 0.8)
	pass
