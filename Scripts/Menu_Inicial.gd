extends Node
# Called when the node enters the scene tree for the first time.
func _ready():
	$varsContainer/nCaixas/inputCaixas.text = str(Levels.levels["-1"]["nCaixas"])
	$varsContainer/nBolas/inputBolas.text = str(Levels.levels["-1"]["nBolas"])
	$varsContainer/altura/inputAltura.text = str(Levels.levels["-1"]["x_tam"])
	$varsContainer/largura/inputLargura.text = str(Levels.levels["-1"]["z_tam"])
	#GlobalVar.cdRoll = $varsContainer/cdRoll/inputCdRoll.text
	$varsContainer/walkingSPEED/inputWalkingSPEED.text = str(GlobalVar.walkingSPEED)
	$varsContainer/runningSPEED/inputRunningSPEED.text = str(GlobalVar.runningSPEED)
	$varsContainer/staRecover/inputStaRecover.text = str(GlobalVar.staRecover)
	$varsContainer/staUsage/inputStaUsage.text = str(GlobalVar.staUsage)
	$balancingMode.button_pressed = GlobalVar.balancingMode
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print_debug(GlobalVar.balancingMode)
	pass

func _on_button_pressed():
	if GlobalVar.balancingMode:
		GlobalVar.currentLevel = -1
	else:
		GlobalVar.currentLevel = 1
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
		


func _on_input_sta_recover_text_changed(new_text):
	GlobalVar.staRecover = float(new_text)


func _on_input_sta_usage_text_changed(new_text):
	GlobalVar.staUsage = float(new_text)


func _on_input_walking_speed_text_changed(new_text):
	GlobalVar.walkingSPEED = float(new_text)


func _on_input_running_speed_text_changed(new_text):
	GlobalVar.runningSPEED = float(new_text)

func _on_input_caixas_text_changed(new_text):
	Levels.levels["-1"]["nCaixas"] = int(new_text)

func _on_input_bolas_text_changed(new_text):
	Levels.levels["-1"]["nBolas"] = int(new_text)

func _on_input_altura_text_changed(new_text):
	Levels.levels["-1"]["x_tam"] = int(new_text)

func _on_input_largura_text_changed(new_text):
	Levels.levels["-1"]["z_tam"] = int(new_text)

func _on_balancing_mode_toggled(toggled_on):
		GlobalVar.balancingMode = toggled_on
		$varsContainer.visible = toggled_on
