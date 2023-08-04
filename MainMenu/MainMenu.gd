extends Node2D

@onready var host_button = $CenterContainer/VBoxContainer/HostButton
@onready var ip_line_edit = $CenterContainer/VBoxContainer/IPEdit

var is_server = true
var world_scene = preload("res://game.tscn")

func _ready():
	update_ui()
	
func update_ui():
	host_button.set_pressed_no_signal(is_server)
	ip_line_edit.set_editable(not is_server)

func _on_host_toggled(button_pressed):
	is_server = button_pressed
	update_ui()

func _input(event):
	if event is InputEventKey and \
		(event as InputEventKey).pressed and \
		(event as InputEventKey).keycode == KEY_ENTER:
			
		NetworkGlobals.is_server = is_server
		NetworkGlobals.host_ip = "127.0.0.1" if is_server else (ip_line_edit as LineEdit).text 		
		get_tree().change_scene_to_packed(world_scene)
