extends RigidBody3D

var ui_box
# Called when the node enters the scene tree for the first time.
func _ready():
	#print_debug(position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_caixa_area_area_entered(area):
	print_debug(area.collision_mask)
	GlobalVar.pontos += 1
	ui_box.queue_free()
	queue_free()
	pass # Replace with function body.
