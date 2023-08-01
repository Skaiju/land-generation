extends Node3D

var movement_offset: Vector3
var move_sensitivity: float = 0.5

var zoom_offset: float
var zoom_sensitivity: float = 15
var zoom_min: float = 20
var zoom_max: float = 200

var pitch: float
var pitch_sensitivity: float = 0.005
var pitch_min: float = deg_to_rad(-10)
var pitch_max: float = deg_to_rad(-50)

var yaw: float
var yaw_sensitivity: float = 0.01

@onready var cam : Camera3D = $Camera3D
@onready var target: Node3D = $"../"


func _ready():
	movement_offset = position
	zoom_offset = cam.position.z
	pitch = rotation.x


func _physics_process(delta):
	# Update zoom
	cam.position = lerp(cam.position, zoom_offset * Vector3.FORWARD, 0.05)
	
	# Update rotation
	var lerp_rotation = rotation
	lerp_rotation.x = lerp(rotation.x, pitch, 0.05)
	lerp_rotation.y = lerp(rotation.y, yaw, 0.05)
	set_rotation(lerp_rotation)
	
	# Update movement
	position = lerp(position, basis * movement_offset, 0.5)


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
		movement_offset = target.position
	
