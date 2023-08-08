class_name GlobalCamera extends Node3D

@onready var target_node: Node3D = $".."
var target_position: Vector3 :
	get: return get_target_position()


@onready var cam : Camera3D = $Camera3D

var movement_offset: Vector3 = Vector3.ZERO
var move_sensitivity: float = 0.5


var zoom_offset: float
var zoom_sensitivity: float = 15
var zoom_min: float = 20
var zoom_max: float = 2000


var pitch: float
var pitch_sensitivity: float = 0.005
var pitch_min: float = deg_to_rad(-10)
var pitch_max: float = deg_to_rad(-50)


var yaw: float
var yaw_sensitivity: float = 0.01


var smoothness: float = 0.05



func _ready():
	zoom_offset = cam.position.z
	pitch = rotation.x
	
func _physics_process(delta):
	# Update CameraPivot position to focused object
	position = lerp(position, target_position, smoothness)
	
	# Update zoom
	cam.position = lerp(cam.position, zoom_offset * Vector3.FORWARD, smoothness)
	
	# Update rotation
	var lerp_rotation = rotation
	lerp_rotation.x = lerp(rotation.x, pitch, smoothness)
	lerp_rotation.y = lerp(rotation.y, yaw, smoothness)
	set_rotation(lerp_rotation)


func _input(event):
	# Hanlde zoom
	if event is InputEventMouseButton:
		var delta_zoom = Input.get_axis("zoom_out", "zoom_in")
		zoom_offset += zoom_sensitivity * delta_zoom
		zoom_offset = clampf(zoom_offset, -zoom_max, -zoom_min)
	
	# Handle rotation: while mouse is moving
	if event is InputEventMouseMotion:
		var relative_delta = (event as InputEventMouseMotion).relative
		
		# Handle rotation
		if Input.is_action_pressed("free_rotation"): 
			pitch -=  pitch_sensitivity * relative_delta.y
			pitch = clampf(pitch, pitch_max, pitch_min)
			
			yaw -= yaw_sensitivity * relative_delta.x
		
		# Handle movement
		elif Input.is_action_pressed("free_movement"):
			# Stop lerping to rotations
			pitch = rotation.x
			yaw = rotation.y
			
			# Get movement
			var direction = Vector3(-relative_delta.x, relative_delta.y, 0)
			movement_offset += move_sensitivity * direction

	# Handle focus
	if Input.is_action_just_pressed("focus"):
		movement_offset = Vector3.ZERO


func get_target_position() -> Vector3:
	return target_node.position + basis * movement_offset
