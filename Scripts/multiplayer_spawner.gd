extends MultiplayerSpawner


var player_prefab = preload("res://Prefabs/player.tscn")

func _ready() -> void:
	#add_spawnable_scene("res://Prefabs/player.tscn")
	set_spawn_function(_spawner)


func _spawner(player):
	print_debug(multiplayer.get_unique_id())
	if not Lobby.is_multiplayer_enabled: return
	
	print("spawn")
	var _player = player_prefab.instantiate()
	_player.player_info = player[1]
	_player.name = str(player[0])
	_player.position = Levels.generate_spwn_point(0)
	return _player
