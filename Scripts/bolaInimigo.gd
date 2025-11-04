extends CharacterBody3D

var spdx = RandomNumberGenerator.new().randf_range(-1,1)
var spdz = RandomNumberGenerator.new().randf_range(-1,1)
var SPEED:Vector3 = Vector3(spdx,0,spdz).normalized() * RandomNumberGenerator.new().randi_range(8,14)

func _physics_process(delta):
	var colisao = move_and_collide(SPEED*delta)
	if colisao:
		SPEED = SPEED.bounce(colisao.get_normal())
		colisao = null


func _on_bola_area_body_entered(_body):
	get_tree().change_scene_to_file("res://Scenes/derrota.tscn")
