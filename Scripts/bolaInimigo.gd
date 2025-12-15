extends CharacterBody3D
class_name Inimigo

var spdx = RandomNumberGenerator.new().randf_range(-1,1)
var spdz = RandomNumberGenerator.new().randf_range(-1,1)
var SPEED:Vector3 = Vector3(spdx,0,spdz).normalized() * RandomNumberGenerator.new().randi_range(8,14)

func _physics_process(delta):
	var colisao = move_and_collide(SPEED*delta)
	if colisao:
		#print_debug("COLICIU COM %S" % colisao)
		SPEED = SPEED.bounce(colisao.get_normal())
		#print(colisao.get_collider().get_collision_layer())
		if colisao.get_collider().get_collision_layer() == 16: #valor da layer da galinha
			#if Lobby.is_multiplayer_enabled
			get_tree().change_scene_to_file("res://Scenes/derrota.tscn")
		colisao = null


func _on_bola_area_body_entered(_body):
	#get_tree().change_scene_to_file("res://Scenes/derrota.tscn")
	pass
