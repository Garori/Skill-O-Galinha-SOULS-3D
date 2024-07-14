extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVar.nCaixas = $ColorRect/nCaixas/inputCaixas.text
	GlobalVar.nBolas = $ColorRect/nBolas/inputBolas.text
	GlobalVar.cdRoll = $ColorRect/cdRoll/inputCdRoll.text
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_caixas_text_changed(new_text):
	GlobalVar.nCaixas = int(new_text)
	pass # Replace with function body.


func _on_input_bolas_text_changed(new_text):
	GlobalVar.nBolas = int(new_text)
	
	pass # Replace with function body.

func _on_input_cd_roll_text_changed(new_text):
	GlobalVar.cdRoll = int(new_text)
	pass # Replace with function body.


func _on_button_pressed():
	#SaveManager.save(nCaixas,nBolas,cdRoll)
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
	pass # Replace with function body.

func _input(event):
	#print_debug(event)
	if event is InputEventMouseMotion:
		pass
		#rotation.y -= event.relative.x/sensivity
		#$CameraPivot.rotation.x -= event.relative.y/sensivity
		#$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-65),deg_to_rad(0))
		#print_debug(rotation.y)
	elif event is InputEventJoypadMotion:
		#print_debug(event.axis)
		pass
		#print_debug(event.axis_value)
		#if event.axis == 2:
			#rotation.y -= event.axis_value*10/sensivity
		#elif event.axis == 3:
			#$CameraPivot.rotation.x -= event.axis_value*10/sensivity
			#$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-65),deg_to_rad(0))
		
