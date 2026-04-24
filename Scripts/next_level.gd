extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if Lobby.is_multiplayer_enabled and multiplayer.get_unique_id() != 1:
		$Label.text = "Wait for the host player to start the next level"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event: InputEvent) -> void:
	if event.is_action("next_level"):
		if Lobby.is_multiplayer_enabled and multiplayer.is_server():
			print_debug(Lobby.players)
			Lobby.load_game.rpc("res://Scenes/game.tscn")
		elif not Lobby.is_multiplayer_enabled:
			get_tree().change_scene_to_file("res://Scenes/game.tscn")
