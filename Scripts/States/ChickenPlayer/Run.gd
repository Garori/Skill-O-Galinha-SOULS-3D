class_name ChickenRun
extends ChickenWalk

@onready var runningSPEED = GlobalVar.runningSPEED if GlobalVar.balancingMode else 10.0

func enter():
	player.SPEED = runningSPEED


func physics_update(_delta: float):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if !input_dir:
		Transitioned.emit(self, "idle")

	walk(input_dir)

	player.stamina -= player.staUsage

