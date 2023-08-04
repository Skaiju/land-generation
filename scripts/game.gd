extends Node3D

var TANK_PREFAB = preload("res://Assets/tank/tank.tscn")
@onready var tank_container: Node = $Tanks

var mpeer = ENetMultiplayerPeer.new()


func _ready():
	if NetworkGlobals.is_server:
		mpeer.create_server(NetworkGlobals.PORT)
		mpeer.connect("peer_connected", _on_player_connected)
		_on_player_connected()
	else:
		mpeer.create_client(NetworkGlobals.host_ip, NetworkGlobals.PORT)
	
	multiplayer.multiplayer_peer = mpeer


func _on_player_connected(id: int = 1):
	print("player connected: ", id)	
	var tank = TANK_PREFAB.instantiate() as CharacterBody3D
	tank.name = str(id)
	tank_container.add_child.call_deferred(tank)
	
