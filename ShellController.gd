extends CharacterBody3D

const speed: float = 50
const max_lifetime: float = 5

func _ready():
	get_tree() \
		.create_timer(max_lifetime) \
		.timeout.connect(queue_free)

func _physics_process(delta):
	var collision = move_and_collide(speed * delta *  (transform.basis.z))
	if not collision: return
	
	var is_tank = (collision.get_collider() as Node).get_parent().name == "Tanks"
	if not is_tank:
		queue_free()
		return
		
	var tank = collision.get_collider() as Tank
	tank.take_damage()
