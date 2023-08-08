class_name MapGenerator extends Node3D

const block:= preload("res://assets/block.tscn")
const tree:= preload("res://assets/tree.tscn")
const sand:= preload("res://mats/ground_sand.tres")

signal done_generating


func gen_map(_seed: int = 1):
	seed(_seed) # global seed	
	var num_cubes: int = 0
	
	var fast_noise = FastNoiseLite.new()
	var radius:float = 100
	var offset = randi() % 1000
	var noise_scale: float = 0.8
	var amplitude: float = 20 * 10
	var edge_amplitude: float = 0
	
	
	
	
	for i in range(-radius * (1 + edge_amplitude), radius * (1 + edge_amplitude)):
		for j in range(-radius * (1 + edge_amplitude), radius * (1 + edge_amplitude)):
			var this_radius: float = sqrt(pow(i, 2) + pow(j, 2))
			
			# If this block is outside the readius, try randomise coast
			if this_radius > radius:
				# NB: Use positive coast only
				var extra_coast: float =  edge_amplitude * (1 + fast_noise.get_noise_2d(i, j)) / 2.0
				var noise_radius =  radius * (1 + extra_coast)
				if this_radius > noise_radius: continue

			# Randomise block height
			var this_block = block.instantiate(); num_cubes+=1
			var noise_height = fast_noise.get_noise_2d(offset + noise_scale * i,offset + noise_scale * j)
			
			var height = amplitude * drop_off(this_radius/radius) * exp_height(noise_height)
#			var height = amplitude * drop_off(this_radius/radius)
			height = mod_height(height)
			
			this_block.position = Vector3(
				i,
				height,
				j
			)
					
			if this_block.position.y < 1:
				(this_block.get_node("MeshInstance3D") as MeshInstance3D).set_surface_override_material(0, sand)
			else:
				var tree_scale = 0.4
				var h = fast_noise.get_noise_2d(offset*5+noise_scale*i,offset*5+noise_scale*j)

				if h > 0 and randf() <  0.3 * h:
					var pos = this_block.position
					pos.y += this_block.scale.y/2
					var this_tree = tree.instantiate()
					this_tree.position = pos
					add_child(this_tree)

					
			add_child(this_block)
	
	print("Spawned ", num_cubes, " cubes")
	done_generating.emit()


func drop_off(radius: float, cliff_steep: float = 32, platuea: float = 28):
	return 1.0 / (1 + 2.71828 ** (radius * cliff_steep - platuea))
	

func mod_height(y: float, mod: int = 2, decimals: int = 1):
	# Eg, y = -0.65
	var s = sign(y) # s = -1	
	y = int(decimals * 10 * abs(y))  # y = 6
	y -= ((y as int) % mod) # y = 6 - 2 = 4
	y *= decimals * 0.1 # y = 0.4
	return s * y # -0.4
	
	
func exp_height(x: float, scale: float = 3):
	x = clampf(x, -1, 1)
	return 2.71828 ** (x * scale - scale)
