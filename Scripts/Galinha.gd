class_name Chicken
extends CharacterBody3D


var SPEED
@onready var staRecover = GlobalVar.staRecover if GlobalVar.balancingMode else 0.35
@onready var staUsage = GlobalVar.staUsage if GlobalVar.balancingMode else 1.
@export var SENSIVITY = 300


@onready var defaultCameraPosition = $CameraPivot/Camera3D.position
@onready var defaultCameraPivotPosition = $CameraPivot.position
@onready var statusContainerInitialPosition = $PlayerUI/statusContainer.position
@onready var camera := $CameraPivot/Camera3D
@onready var progressBar:ProgressBar = $PlayerUI/statusContainer/ProgressBar
@onready var unabletoRoll:Label = $PlayerUI/statusContainer/unableToRoll
@onready var unableToRun:Label = $PlayerUI/statusContainer/UnableToRun
@onready var info_tag:SubViewport = $Info/SubViewport

@onready var sprite = $Sprite
@export var stamina:float

var mayTheChickenRoll: bool
var mayTheChickenRun: bool
var last
var modRED = 1*(100-stamina)/100
var modGREEN = 1*(stamina)/100
var t_passed = 0
var new_pos_fixed = Vector2(0,0)

const JOY_DEADZONE = 0.1
const JOY_AXIS_RESCALE = 1.0/(1.0-JOY_DEADZONE)
const JOY_ROTATION_MULTIPLIER = 200.0 * PI / 180.0

var player_info = {}

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready():
	#print_debug(nickname)
	if not Lobby.is_multiplayer_enabled:
		info_tag.get_parent().visible = false
		pass
	else:
		if is_multiplayer_authority():
			var a:Label
			camera.make_current()
			info_tag.get_node("ColorRect").modulate = player_info["color"]
			info_tag.get_node("Nickname").modulate.a = 1.0
			info_tag.get_node("Nickname").text = player_info["name"]
			info_tag.get_parent().visible = false
		else:
			$PlayerUI/statusContainer.visible = false
		
		
		
	$arma.visible = false
	#$arma.set_process(false)
	$arma/armaArea/armaCollision.disabled = true
	#$arma/armaFisico.disabled = true
	last = "default_esq"
	mayTheChickenRoll = true
	mayTheChickenRun = true
	unabletoRoll.visible = not mayTheChickenRoll
	unableToRun.visible = not mayTheChickenRun
	stamina = 100
	



func _physics_process(delta):	
	if Lobby.is_multiplayer_enabled and not is_multiplayer_authority(): return
	# Node2D.get_mouse_global_position()
	# get_viewport().warp_mouse(new_pos)
	var screen_pos = camera.unproject_position(global_position + Vector3(0, -0.2-$CollisionShape3D.shape.size.y/2, 0)) 
	$PlayerUI.global_position = screen_pos + Vector2(-$PlayerUI/statusContainer/ProgressBar.get_rect().size.x / 2, 0)

	# $PlayerUI.global_position += Vector2(-$PlayerUI/statusContainer/ProgressBar.get_rect().size.x / 2, 0)
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if is_on_floor():
		$Sprite.animation = last
	
	progressBar.value = stamina
	unabletoRoll.visible = not mayTheChickenRoll
	unableToRun.visible = not mayTheChickenRun
	
	if stamina>95:
		mayTheChickenRun = true
	if stamina<80:
		mayTheChickenRoll = false
	elif stamina>=80 and mayTheChickenRun:
		mayTheChickenRoll = true
	
	if stamina <30:
		modRED = 1
		modGREEN = 0
	elif stamina>80:
		modGREEN = 1
		modRED = 0
	else:
		modRED = 1*(100-stamina)/100
		modGREEN = 1*(stamina)/100
		
	progressBar.modulate = Color(modRED,modGREEN,0)
	
	#if move_and_collide():
		#pass
	move_and_slide()
	#nickname.position.x = position.x
	#nickname.position.z = position.z
	
	if Input.is_action_pressed("zoom_in"):
		$CameraPivot/Camera3D.position.y -= 0.1
		$CameraPivot/Camera3D.position.z -= 1.0
	if Input.is_action_pressed("zoom_out"):
		$CameraPivot/Camera3D.position.y += 0.1
		$CameraPivot/Camera3D.position.z += 1.0
			
	if Input.get_connected_joypads().size() == 0:
		return
		
	var xAxis = Input.get_joy_axis(0, 2)
	if abs(xAxis) > JOY_DEADZONE:
		if xAxis >0:
			xAxis = (xAxis-JOY_DEADZONE) * JOY_AXIS_RESCALE
		else:
			xAxis = (xAxis+JOY_DEADZONE) * JOY_AXIS_RESCALE
		rotation.y -= xAxis*10/SENSIVITY
		#$CameraPivot.rotate_object_local(Vector3.UP, -xAxis * delta * JOY_ROTATION_MULTIPLIER)
		
	var yAxis = Input.get_joy_axis(0, 3)
	if abs(yAxis) > JOY_DEADZONE:
		if yAxis >0:
			yAxis = (yAxis-JOY_DEADZONE) * JOY_AXIS_RESCALE
		else:
			yAxis = (yAxis+JOY_DEADZONE) * JOY_AXIS_RESCALE
		$CameraPivot.rotation.x -= yAxis*10/SENSIVITY
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-65),deg_to_rad(0))
		
		

	
func _input(event):
	
			
	if Lobby.is_multiplayer_enabled and not is_multiplayer_authority(): return
	
	if event.is_action_pressed("sui_test"):
		queue_free()

	if event.is_action_pressed("ui_attack") and is_on_floor():
		$arma/animacao.play("attack")
	
	if event.is_action_pressed("dodge_roll") and is_on_floor() and mayTheChickenRoll:
		$animacao.play("rolamento")


	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$CameraPivot/Camera3D.position.y -= 0.1
			$CameraPivot/Camera3D.position.z -= 1.0
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$CameraPivot/Camera3D.position.y += 0.1
			$CameraPivot/Camera3D.position.z += 1.0
			
		$CameraPivot/Camera3D.position.y = clampf($CameraPivot/Camera3D.position.y, 0.3, 4)
		$CameraPivot/Camera3D.position.z = clampf($CameraPivot/Camera3D.position.z, 3, 40)
		# $PlayerUI.scale= Vector2(25/$CameraPivot/Camera3D.position.z,25/$CameraPivot/Camera3D.position.z)
		
		
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x/SENSIVITY
		$CameraPivot.rotation.x -= event.relative.y/SENSIVITY
		#if not aimPressed:
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-65),deg_to_rad(0))
		#print_debug(rotation.y)
	#elif event is InputEventJoypadMotion and abs(event.axis_value)>0.1:
		##print_debug(event.axis)
		##print_debug(event.axis_value)
		#if event.axis == 2:
			#rotation.y -= event.axis_value*10/SENSIVITY
		#elif event.axis == 3:
			#$CameraPivot.rotation.x -= event.axis_value*10/SENSIVITY
			#$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-65),deg_to_rad(0))
		
