extends CharacterBody3D


const SPEED = 1000
const JUMP_VELOCITY = 20
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


func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	if not is_multiplayer_authority(): return
	
	($"../../CameraPivot" as GlobalCamera).target_node = self
	
	position = randf_range(-1,1) * 50 * Vector3.ONE
	position.y = 50

func _input(event):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("enter_fpv"):
		change_view()
			
	if (cam_view != camera_state.NOT_FOCUSED) and event is InputEventMouseMotion:
		var delta = event.relative
		turret.rotate_y(SENSITIVITY * -delta.x)
		barrel.rotate_x(SENSITIVITY * delta.y)
		barrel.rotation_degrees.x = clampf(barrel.rotation_degrees.x, -25, 0)

		

func change_view():
	cam_view = (cam_view + 1) % 3

	
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


func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var input_dir = Input.get_vector("move_right", "move_left", "move_forward", "move_back")
	
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
