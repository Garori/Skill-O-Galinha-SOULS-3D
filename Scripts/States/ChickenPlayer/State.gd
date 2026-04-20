extends State
class_name ChickenState

var player: Chicken

func _ready() -> void:
	player = get_parent().get_parent()

func check_for_ovo():
	if Input.is_action_just_pressed("drop_ovo") and player.mayTheChickenOvo and player.stamina >=100:
		print_debug("OVO")
		Transitioned.emit(self, "ovo")
		print_debug("after ovo")
