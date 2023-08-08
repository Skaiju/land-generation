extends Node2D

@onready var fps: Label = $FPS


func _process(delta):
	fps.text = str(1/delta)
