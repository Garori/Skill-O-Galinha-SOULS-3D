extends Node

var t_passed = 0
var new_pos_fixed = Vector2(0,0)
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


func _on_start_game_pressed() -> void:
	if GlobalVar.balancingMode:
		Levels.set_current_level.rpc(-1)
	else:
		Levels.set_current_level.rpc(1)
		
	if Lobby.is_multiplayer_enabled:
		Lobby.load_game.rpc("res://Scenes/game.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/game.tscn")


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


func _on_online_mode_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Lobby.is_multiplayer_enabled = true
		get_node("%multiplayerMenu").visible = true
		get_node("%StartGame").disabled = true
		get_node("%balancingMode").button_pressed = false
	else:
		Lobby.is_multiplayer_enabled = false
		get_node("%StartGame").disabled = false
		get_node("%multiplayerMenu").visible = false
