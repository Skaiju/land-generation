extends CharacterBody3D


const SPEED = 250
const JUMP_VELOCITY = 5
const SENSITIVITY: float = 0.001

var gravity = 9.8

var cam_view = camera_state.NOT_FOCUSED

enum camera_state
{
	NOT_FOCUSED,
	FPV,
	TPV
}


@onready var fpv_camera: Camera3D = $Body/Turret/Barrel/Camera3D
@onready var tpv_camera: Camera3D = $Body/Turret/TPVCam
@onready var turret: Node3D = $Body/Turret
@onready var barrel: Node3D = $Body/Turret/Barrel

func _ready():
	cam_view += 1
	print(cam_view)  

func _input(event):
	if Input.is_action_just_pressed("enter_fpv"):
		change_view()
			
	if (cam_view != camera_state.NOT_FOCUSED) and event is InputEventMouseMotion:
		var delta = event.relative
		turret.rotate_y(SENSITIVITY * -delta.x)
		barrel.rotate_x(SENSITIVITY * delta.y)
		barrel.rotation_degrees.x = clampf(barrel.rotation_degrees.x, -25, 0)

		

func change_view():
	cam_view += 1
	cam_view = cam_view % 3

	
	match cam_view:
		camera_state.NOT_FOCUSED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			fpv_camera.current = false
			tpv_camera.current = false
		camera_state.FPV:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			fpv_camera.current = true
			tpv_camera.current = false
		camera_state.TPV:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			fpv_camera.current = false
			tpv_camera.current = true
		_:
			print("default")
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	var input_dir = Input.get_vector("move_right", "move_left", "move_forward", "move_back")
	
	# Hanlde rotate
	if input_dir.x != 0: rotate_y(delta * sign(input_dir.x) * deg_to_rad(30))
	
	# Handle movement
	if input_dir.y != 0:
		var movement = transform.basis * Vector3.FORWARD * delta * SPEED * sign(input_dir.y)
		velocity.x = movement.x
		velocity.z = movement.z
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()