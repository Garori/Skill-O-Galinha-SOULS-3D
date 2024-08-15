extends CharacterBody3D


var SPEED
@onready var walkingSPEED = GlobalVar.walkingSPEED if GlobalVar.balancingMode else 5.0
@onready var runningSPEED = GlobalVar.runningSPEED if GlobalVar.balancingMode else 10.0
@onready var staRecover = GlobalVar.staRecover if GlobalVar.balancingMode else 0.35
@onready var staUsage = GlobalVar.staUsage if GlobalVar.balancingMode else 1.
@export var sensivity = 300
var last
@export var mayTheChickenRoll: bool

@export var mayTheChickenRun: bool
var aimPressed = false
@onready var defaultCameraPosition = $CameraPivot/Camera3D.position
@onready var defaultCameraPivotPosition = $CameraPivot.position
@onready var progressBar:ProgressBar = $statusContainer/ProgressBar
@onready var unabletoRoll:Label = $statusContainer/unableToRoll
@onready var unableToRun:Label = $statusContainer/UnableToRun
const bala = preload("res://Prefabs/bala.tscn")
var direction
@export var stamina:float = 100.0
var modRED = 1*(100-stamina)/100
var modGREEN = 1*(stamina)/100

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
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
	#atacar = false

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Add the gravity.
	#if Input.is_action_just_pressed("aim"):
		#$CameraPivot/Camera3D.rotation.x = 0
		#$CameraPivot.rotation.x = 0
		#$CameraPivot.position.y=0
		#$CameraPivot/Camera3D.position=Vector3(0,0,0.9)
		#$CameraPivot/Camera3D.fov = 5
		#sensivity = 1200
		#SPEED = 2.0
	#if Input.is_action_just_released("aim"):
		#aimPressed = false
		#$CameraPivot/Camera3D.position=defaultCameraPosition
		#$CameraPivot.position=defaultCameraPivotPosition
		#$CameraPivot/Camera3D.fov = 55.3
		#sensivity = 300
		#SPEED = 5.0
	#if Input.is_action_pressed("aim"):
		#aimPressed = true
		#return
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_pressed("ui_right"):
		last = "default_dir"
	elif Input.is_action_pressed("ui_left"):
		last = "default_esq"
	
	if is_on_floor():
		$Sprite.animation = last
	
	if Input.is_action_just_pressed("ui_attack") and is_on_floor():
		$arma/animacao.play("attack")
	
	if Input.is_action_just_pressed("dodge_roll") and is_on_floor() and mayTheChickenRoll:
		$animacao.play("rolamento")
		pass

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("run") and stamina > 0.5 and mayTheChickenRun and input_dir != Vector2(0,0):
		SPEED = runningSPEED
		stamina -= staUsage
		#print_debug(stamina)
	elif not Input.is_action_pressed("run") or (Input.is_action_pressed("run") and (not mayTheChickenRun or input_dir == Vector2(0,0))):
		#print_debug(input_dir)
		SPEED = walkingSPEED
		if stamina <100:
			stamina += staRecover
		if stamina>95:
			mayTheChickenRun = true
	#if Input.is_action_just_released("run"):
		#if stamina<15:
			#mayTheChickenRun = false
	if (Input.is_action_just_released("run") and stamina <=30) or stamina<5:
		mayTheChickenRun = false
		mayTheChickenRoll = false
		
	progressBar.value = stamina
	unabletoRoll.visible = not mayTheChickenRoll
	unableToRun.visible = not mayTheChickenRun
	
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
	
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		$Sprite.play()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$Sprite.stop()
	
	move_and_slide()
	
func _input(event):
	#if aimPressed and event is InputEventMouseButton and event.button_index == 1 and event.is_action_pressed("ui_attack"):
		#var obj:Object = bala.instantiate()
		#obj.position = position
		#var calculo = obj.transform.basis * ($CameraPivot/saidaDeBalas.global_position-position).normalized()
		#obj.direction = Vector3(calculo.x,$CameraPivot.rotation.x,calculo.z) * 100
		#obj.rotation = Vector3($CameraPivot.rotation.x,rotation.y,0)
		##print_debug($saidaDeBalas.position-position)
		##print_debug(obj.rotation)
		#get_parent().add_child(obj)
		
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x/sensivity
		$CameraPivot.rotation.x -= event.relative.y/sensivity
		#if not aimPressed:
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-65),deg_to_rad(0))
		#print_debug(rotation.y)
	elif event is InputEventJoypadMotion and abs(event.axis_value)>0.05:
		#print_debug(event.axis)
		#print_debug(event.axis_value)
		if event.axis == 2:
			rotation.y -= event.axis_value*10/sensivity
		elif event.axis == 3:
			$CameraPivot.rotation.x -= event.axis_value*10/sensivity
			$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-65),deg_to_rad(0))
		

