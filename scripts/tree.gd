extends StaticBody3D

@onready var collision_shape = $CollisionShape3D
var mat = preload("res://mats/leaf.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	change_leaves()

func change_leaves():
	var leaves = collision_shape.get_children() as Array[MeshInstance3D]
	for i in leaves.size():
		var new_mat = mat.duplicate()
		var s_offset = randf_range(-0.4,0.4)
		var saturation = clampf(new_mat.albedo_color.s + s_offset, 0, 1)
		new_mat.albedo_color.s = saturation
		leaves[i].set_surface_override_material(0, new_mat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
