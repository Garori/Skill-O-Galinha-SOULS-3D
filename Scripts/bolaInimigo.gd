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
		#print_debug(get_tree().get_nodes_in_group("Players_group"))
		var collider = colisao.get_collider()
		if collider.get_collision_layer() == 16: #valor da layer da galinha
			#if Lobby.is_multiplayer_enabled
			print_debug("NAME DO COLISOR = %s" % collider.name)
			#if collider.name != "1":
				#Lobby.load_game.call_deferred("res://Scenes/derrota.tscn")
			#else:
			if len(get_tree().get_nodes_in_group("Players_group")) == 1:
				collider.queue_free.call_deferred()
				Lobby.load_game.rpc("res://Scenes/derrota.tscn")
				return
				# MODIFICAR O CÓDIGO PARA PODER FICAR COM A CAMERA LIVRE EM UM AMIGUINHO
			collider.queue_free.call_deferred()



func _on_bola_area_body_entered(_body):
	#get_tree().change_scene_to_file("res://Scenes/derrota.tscn")
	pass
