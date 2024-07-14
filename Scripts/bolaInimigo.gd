extends CharacterBody3D

var spdx = RandomNumberGenerator.new().randf_range(-1,1)
var spdz = RandomNumberGenerator.new().randf_range(-1,1)
var SPEED:Vector3 = Vector3(spdx,0,spdz).normalized() * RandomNumberGenerator.new().randi_range(8,14)

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass
	#SPEED.normalized()
	#if SPEED.abs()

func _physics_process(delta):
	#print_debug(SPEED)
	var colisao = move_and_collide(SPEED*delta)
	if colisao:
		#print_debug(colisao.get_normal())
		SPEED = SPEED.bounce(colisao.get_normal())
		colisao = null


func _on_bola_area_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/derrota.tscn")
	pass # Replace with function body.
