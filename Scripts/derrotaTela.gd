extends Node3D

@onready var estrela = preload("res://Prefabs/estrela.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if Lobby.is_multiplayer_enabled and multiplayer.get_unique_id() != 1:
		$Label.text = "You can keep waiting for your friend or press ESC to go back to the Menu"
	for i in range(700):
		var obj:OmniLight3D = estrela.instantiate()
		add_child(obj)
		var rng = RandomNumberGenerator.new()
		obj.position = Vector3(rng.randf_range(-1000,1000),rng.randf_range(-1000,1000),rng.randf_range(-1000,1000))
		obj.light_color = Color(rng.randf_range(0,1),rng.randf_range(0,1),rng.randf_range(0,1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame

func _input(event: InputEvent) -> void:
	if Lobby.is_multiplayer_enabled and multiplayer.get_unique_id() != 1:
		if event.is_action_pressed("ui_cancel"):
			get_tree().change_scene_to_file("res://Scenes/Menu_Inicial.tscn")
			return
	elif Lobby.is_multiplayer_enabled:
		if event.is_action_pressed("ui_cancel"):
			Lobby.load_game.rpc("res://Scenes/game.tscn")
			return
		
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	pass
