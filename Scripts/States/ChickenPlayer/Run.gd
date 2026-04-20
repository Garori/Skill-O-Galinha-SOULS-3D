class_name ChickenRun
extends ChickenWalk

@onready var runningSPEED = GlobalVar.runningSPEED if GlobalVar.balancingMode else 10.0

func enter():
	player.SPEED = runningSPEED


func physics_update(_delta: float):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var strength = 1
	if player.stamina < player.staUsage * strength or not player.mayTheChickenRun:
		Transitioned.emit(self, "walk")
		return

	var aux = max(Input.get_joy_axis(0, 4), Input.get_joy_axis(0, 5))

	if Input.get_connected_joypads().size() != 0 and aux > 0.1:
		strength = max(Input.get_joy_axis(0, 4), Input.get_joy_axis(0, 5))
		player.SPEED = 5 + 5*strength

	if not input_dir:
		Transitioned.emit(self, "idle")

	walk(input_dir)

	player.stamina -= player.staUsage * strength
