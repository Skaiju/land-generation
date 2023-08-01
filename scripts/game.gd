extends Node3D
const block:= preload("res://assets/block.tscn")
const tree:= preload("res://assets/tree.tscn")
const sand:= preload("res://mats/ground_sand.tres")


func _ready():
	gen_map()


func gen_map():
	var num_cubes: int = 0
	
	
	var fast_noise = FastNoiseLite.new()
	var size = 150
	var offset = randi() % 1000
	var scale: float = 1.2
	var amplitude: float = 20
	
	for i in range(-size/2,size/2):
		for j in range(-size/2,size/2):
			
			# Randomise island coast
			if (pow(i, 2) + pow(j, 2)) > size * (100 + fast_noise.get_noise_2d(i, j) * 20): continue
			
			# Randomise block height
			var this_block = block.instantiate(); num_cubes+=1
			var noise_height = fast_noise.get_noise_2d(offset + scale * i,offset + scale * j)
			
			this_block.position = Vector3(
				i,
				mod_height(
					amplitude * (drop_off(Vector2(i, j).length()) + 0.2 * noise_height)
				),
				j
			)
					
#			if this_block.position.y < 11:
#				(this_block.get_node("MeshInstance3D") as MeshInstance3D).set_surface_override_material(0, sand)
#			else:
#				var tree_scale = 0.4
#				var h = fast_noise.get_noise_2d(offset*5+scale*i,offset*5+scale*j)
#				if h > 0 and randf() <  0.3 * h:
#					var pos = this_block.position + Vector3.UP 
#					var this_tree = tree.instantiate()
#					this_tree.position = pos
#					add_child(this_tree)
			add_child(this_block)
	
	print("Spawned ", num_cubes, " cubes")

func drop_off(x: float):
	var e = 2.71828
	
	return 1.0 / (1 + pow(e, (abs(x/18) - 8)))
	

func mod_height(y: float, mod: int = 2, decimals: int = 1):
	# y = -0.65
	var s = sign(y) # s = -1	
	y = int(decimals * 10 * abs(y))  # y = 6
	y -= ((y as int) % mod) # y = 6 - 2 = 4
	y *= decimals * 0.1 # y = 0.4
	return s * y # -0.4
	
	
	
	
