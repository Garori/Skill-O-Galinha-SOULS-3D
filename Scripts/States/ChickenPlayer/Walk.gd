class_name ChickenWalk
extends ChickenState

@onready var walkingSPEED = GlobalVar.walkingSPEED if GlobalVar.balancingMode else 5.0
var direction

func enter():
	player.SPEED = walkingSPEED
	pass

func exit():
	pass

func update(_delta: float):
	pass

func walk(input_dir):

	if Input.is_action_pressed("ui_right"):
		player.last = "default_dir"
	elif Input.is_action_pressed("ui_left"):
		player.last = "default_esq"

	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.sprite.play()
		player.velocity.x = direction.x * player.SPEED
		player.velocity.z = direction.z * player.SPEED

	#player.move_and_slide()


func physics_update(_delta: float):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if !input_dir:
		Transitioned.emit(self, "idle")
		return

	if player.stamina < player.max_stamina:
		player.stamina += player.staRecover
	else:
		player.stamina = player.max_stamina

	walk(input_dir)


func handle_input(_event: InputEvent):
	check_for_ovo()

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_pressed("run") and player.stamina > 0.5 and player.mayTheChickenRun and input_dir:
		Transitioned.emit(self, "run")
	# elif input_dir and Input.is_action_pressed("run") and (player.stamina < 0.5 or not player.mayTheChickenRun):
	# 	Transitioned.emit(self, "walk")

	if (Input.is_action_just_released("run") and player.stamina <=30) or player.stamina<5:
		player.mayTheChickenRun = false
		player.mayTheChickenRoll = false
		Transitioned.emit(self, "walk")
	elif Input.is_action_just_released("run"):
		Transitioned.emit(self, "walk")
