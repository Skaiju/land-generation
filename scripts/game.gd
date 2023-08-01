extends Node3D
const block:= preload("res://assets/block.tscn")
const tree:= preload("res://assets/tree.tscn")
const sand:= preload("res://mats/ground_sand.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	gen_map()
#	var scale = 10
#	var fast_noise = FastNoiseLite.new()
#	for i in 10:
#		var noise_height = scale * fast_noise.get_noise_1d(i)
#		var mod_height = ((floor(noise_height * 10) - (int(noise_height * 10) % 4))) / 10
#		print(noise_height)
#		#print(floor(noise_height * 10))
#		#print(mod_height)
#		var this_block = block.instantiate() as StaticBody3D
#		this_block.position = Vector3(i,mod_height,0)


func gen_map():
	var size = 400
	var offset = randi() % 1000
	var scale = 1.2
	var fast_noise = FastNoiseLite.new()
	
	
	
	for i in range(-size/2,size/2):
		for j in range(-size/2,size/2):
			if (pow(i, 2) + pow(j, 2)) > size * (100 + fast_noise.get_noise_2d(i, j) * 20): continue
			
			var this_block = block.instantiate()
			var noise_height = 4 * fast_noise.get_noise_2d(offset+scale*i,offset+scale*j)
			var mod_height = abs((floor(noise_height * 10) - abs(int(noise_height * 10) % 4))) / 10
			
			print(mod_height)
			this_block.position = Vector3(
				i,
				mod_height,
				j
			)		
			if this_block.position.y < 11:
				(this_block.get_node("MeshInstance3D") as MeshInstance3D).set_surface_override_material(0, sand)
			else:
				var tree_scale = 0.4
				var h = fast_noise.get_noise_2d(offset*5+scale*i,offset*5+scale*j)
				if h > 0 and randf() <  0.3 * h:
					var pos = this_block.position + Vector3.UP 
					var this_tree = tree.instantiate()
					this_tree.position = pos
					add_child(this_tree)
			add_child(this_block)

func drop_off(x: float):
	var e = 2.71828
	
	return 1.0 / (1 + pow(e, (abs(x/18) - 8)))


func _process(delta):
	pass
