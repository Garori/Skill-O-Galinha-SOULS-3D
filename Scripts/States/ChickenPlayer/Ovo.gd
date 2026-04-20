class_name ChickenOvo
extends ChickenState

const ovo = preload("res://Prefabs/ovo.tscn")

func enter():
	# print_debug("ENTREI EM OVO")
	player.SPEED = 0
	player.velocity = Vector3(0,0,0)
	if player.sprite:
		player.sprite.stop()
	player.stamina -= 100
	await get_tree().create_timer(1.0).timeout
	player.mayTheChickenOvo = false
	var ovo:Object = ovo.instantiate()
	player.scene.add_child(ovo, true)
	ovo.position = Vector3(player.position.x,0.35,player.position.z)
	player.ovo = ovo

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir:
		if Input.is_action_pressed("run"):
			Transitioned.emit(self, "run")
		else:
			Transitioned.emit(self, "walk")
	else:
		Transitioned.emit(self, "idle")




func physics_update(_delta: float):
	pass
	# if player.stamina <100:
	# 	player.stamina += player.staRecover
