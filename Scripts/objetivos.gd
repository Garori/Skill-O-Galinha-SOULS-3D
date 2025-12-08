extends RigidBody3D

var ui_box

func _on_caixa_area_area_entered(area):
	#print_debug(area.collision_mask)
	GlobalVar.pontos += 1
	ui_box.queue_free()
	queue_free()
