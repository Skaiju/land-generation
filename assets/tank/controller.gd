extends CharacterBody3D


const SPEED = 250
const JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
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
