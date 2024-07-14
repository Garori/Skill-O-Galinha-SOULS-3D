extends Node3D

@onready var estrela = preload("res://Prefabs/estrela.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(700):
		var obj:OmniLight3D = estrela.instantiate()
		add_child(obj)
		var rng = RandomNumberGenerator.new()
		obj.position = Vector3(rng.randf_range(-1000,1000),rng.randf_range(-1000,1000),rng.randf_range(-1000,1000))
		obj.light_color = Color(rng.randf_range(0,1),rng.randf_range(0,1),rng.randf_range(0,1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
	pass
