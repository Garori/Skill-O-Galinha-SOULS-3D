extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var sensivity = 300
var last
@export var mayTheChickenRoll: bool = true
var aimPressed = false
#var atacar
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var defaultCameraPosition = $CameraPivot/Camera3D.position
@onready var defaultCameraPivotPosition = $CameraPivot.position
const bala = preload("res://Prefabs/bala.tscn")
var direction

func _ready():
	$arma.visible = false
	#$arma.set_process(false)
	$arma/leek/armaArea/armaCollision.disabled = true
	last = "default_esq"
	#atacar = false

func _physics_process(delta):
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
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and mayTheChickenRoll:
		$animacao.play("rolamento")
		pass

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
		

