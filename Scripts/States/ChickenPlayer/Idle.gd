class_name ChickenIdle
extends ChickenState

func enter():
	#print_debug(player)
	player.SPEED = 0
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	if player.sprite:
		player.sprite.stop()

func physics_update(_delta: float):
	if player.stamina <100:
		player.stamina += player.staRecover	

func handle_input(_event: InputEvent):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir and not Input.is_action_pressed("run"):
		Transitioned.emit(self, "walk")
	if input_dir and  Input.is_action_pressed("run"):
		Transitioned.emit(self, "run")
