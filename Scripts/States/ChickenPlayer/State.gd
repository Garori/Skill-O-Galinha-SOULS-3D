extends State
class_name ChickenState

var player: Chicken

func _ready() -> void:
	player = get_parent().get_parent()