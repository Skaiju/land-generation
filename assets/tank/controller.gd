extends CharacterBody3D


const SPEED = 250
const JUMP_VELOCITY = 5
const SENSITIVITY: float = 0.001

var gravity = 9.8

var is_fpv = false


@onready var fpv_camera: Camera3D = $Body/Turret/Barrel/Camera3D
@onready var turret: Node3D = $Body/Turret
@onready var barrel: Node3D = $Body/Turret/Barrel

func _input(event):
	if Input.is_action_just_pressed("enter_fpv"):
		change_view()
			
	if (is_fpv or true) and event is InputEventMouseMotion:
		var delta = event.relative
		turret.rotate_y(SENSITIVITY * -delta.x)
		barrel.rotate_x(SENSITIVITY * delta.y)
		barrel.rotation_degrees.x = clampf(barrel.rotation_degrees.x, -25, 0)
		

func change_view():
	is_fpv = not is_fpv
	fpv_camera.current = is_fpv
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_fpv else Input.MOUSE_MODE_VISIBLE
		
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
