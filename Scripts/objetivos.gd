extends RigidBody3D

var ui_box

func _on_caixa_area_area_entered(_area):
	if Lobby.is_multiplayer_enabled:
		get_parent().points_counter.rpc_id(1)
	else:
		get_parent().points_counter()
	#print_debug(get_multiplayer_authority())
	if Lobby.is_multiplayer_enabled and not is_multiplayer_authority(): return
	ui_box.queue_free()
	queue_free()
