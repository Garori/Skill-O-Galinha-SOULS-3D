extends CharacterBody3D


var direction

# Get the gravity from the project settings to be synced with RigidBody nodes.


func _physics_process(delta):
	# Add the gravity.
	var colisao = move_and_collide(direction*delta)
	if colisao:
		#print_debug(colisao.get_normal())
		direction = direction.bounce(colisao.get_normal())
		colisao = null
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	move_and_slide()





func _on_area_3d_area_entered(area):
	queue_free()
	pass # Replace with function body.


func _on_area_3d_body_entered(body):
	queue_free()
	pass # Replace with function body.
